//
//  ConnectionHandler.swift
//  zero_proj
//
//  Created by Philipp Kotte on 03.07.25.
//

import Foundation
import Network

final class ConnectionHandler: @unchecked Sendable{
    private let connection: NWConnection
    private let parser = HTTPParser()
    private let router: @Sendable (HttpRequest) -> HttpResponse
    
    init(connection: NWConnection, router: @escaping @Sendable (HttpRequest) -> HttpResponse) {
        self.connection = connection
        self.router = router
        print("✅ Neue Verbindung angenommen: \(connection.endpoint)")
    }
    
    func start(){
        connection.stateUpdateHandler = { newState in
            if case .failed(let error) = newState {
                print("❌ Connection failed: \(error.localizedDescription)")
            }
        }
        receive()
        connection.start(queue: .global())
    }
    
    private func receive(){
        connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { [weak self] (data, _, isComplete, error) in
            guard let self = self, let data = data, !data.isEmpty else {
                self?.connection.cancel()
                return
            }
            
            // 1. Daten parse
            guard let request = self.parser.parse(data: data) else {
                let badRequest = HttpResponse(status: .badRequest, statusPhrase: "Bad Request")
                self.send(response: badRequest)
                return
            }
            
            let response = self.router(request)
            
            self.send(response: response)
            
            // Wenn die Verbindung nicht "keep-alive" ist, schließe sie.
            self.connection.cancel()
            
        }
    }
    
    private func send(response: HttpResponse) {
        var responseString = "HTTP/1.1 \(response.status) \(response.statusPhrase)\r\n"
        var headers = response.headers
        
        if let boy = response.body {
            headers["Content-Length"] = String(boy.count)
        }else{
            headers["Content-Length"] = "0"
        }
        
        for (key, value) in headers.storage { //Annahme storage ist [String: String]
            responseString += "\(key): \(value)\r\n"
        }
        responseString += "\r\n"
        
        var responseData = responseString.data(using: .utf8)
        
        if let body = response.body {
            responseData?.append(body)
        }

        connection.send(content: responseData, completion: .contentProcessed({ _ in
            self.connection.cancel()
        }))
    }
}
