//
//  ConnectionHandler.swift
//  zero_proj
//
//  Created by Philipp Kotte on 03.07.25.
//

import Foundation
import Network

final class ConnectionHandler: @unchecked Sendable {
    private let connection: NWConnection
    private let parser = HTTPParser()
    private let router: @Sendable (HttpRequest) -> HttpResponse
    private var receivedData = Data()

    init(connection: NWConnection, router: @escaping @Sendable (HttpRequest) -> HttpResponse) {
        self.connection = connection
        self.router = router
    }

    func start() {
        connection.stateUpdateHandler = self.handleStateChange
        receive()
        connection.start(queue: .global(qos: .userInitiated))
    }
    
    private func handleStateChange(to state: NWConnection.State) {
        switch state {
        case .failed(let error):
            print("❌ Verbindung fehlgeschlagen: \(error.localizedDescription)")
            self.connection.cancel()
        case .cancelled:
            // Verbindung wurde sauber beendet.
            break
        default:
            break
        }
    }

    private func receive() {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { [weak self] (data, _, isComplete, error) in
            guard let self = self else { return }

            if let data = data, !data.isEmpty {
                self.receivedData.append(data)
                self.processBufferedData()
            }
            
            if isComplete || error != nil {
                self.connection.cancel()
            } else {
                // Höre weiter auf neue Daten
                self.receive()
            }
        }
    }
    
    private func processBufferedData() {
        // Versuche, eine vollständige Anfrage aus den gepufferten Daten zu parsen.
        guard let request = self.parser.parse(data: self.receivedData) else {
            // Die Anfrage ist noch nicht vollständig, warte auf mehr Daten.
            return
        }
        
        // Wenn wir eine Anfrage parsen konnten, leere den Puffer.
        self.receivedData.removeAll()
        
        // Verarbeite die Anfrage und sende die Antwort.
        let response = self.router(request)
        self.send(response: response)
    }

    private func send(response: HttpResponse) {
        var responseString = "HTTP/1.1 \(response.status) \(response.statusPhrase)\r\n"
        var headers = response.headers
        
        if let body = response.body {
            headers["Content-Length"] = String(body.count)
        } else {
            headers["Content-Length"] = "0"
        }
        
        headers["Connection"] = "close" // Wir schließen die Verbindung nach jeder Antwort

        headers.forEach { (key, value) in
            responseString += "\(key): \(value)\r\n"
        }
        responseString += "\r\n"

        var responseData = responseString.data(using: .utf8)!
        if let body = response.body {
            responseData.append(body)
        }
        
        connection.send(content: responseData, completion: .contentProcessed({ _ in
            // Schließe die Verbindung, wie im "Connection: close"-Header versprochen.
            self.connection.cancel()
        }))
    }
}
