//
//  TimingMiddleware.swift
//  ZeroHTTP
//
//  Created by Philipp Kotte on 03.07.25.
//

import Foundation
import ZeroLogger

public struct TimingMiddleware: Middleware, Sendable {
    
    private var logger = Logger(label: "zero.http.middleware.timig")
    
    public init() {}
    
    public func handle(request: HttpRequest, next: Responder) -> HttpResponse {
        // 1. Starte die Zeitmessung, bevor die Anfrage weitergereicht wird.
        let startTime = DispatchTime.now()

        // 2. Reiche die Anfrage an die nächste Middleware (oder den Router) weiter.
        // Die `response` erhalten wir erst, nachdem die gesamte Kette durchlaufen wurde.
        var response = next(request)

        // 3. Stoppe die Zeitmessung.
        let endTime = DispatchTime.now()
        
        // 4. Berechne die Dauer.
        let nanoTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000 // In Sekunden
        
        // Formatiere die Dauer für die Ausgabe.
        let duration = String(format: "%.3fms", timeInterval * 1000)

        // 5. Füge einen Header zur Antwort hinzu.
        response.headers.add(name: "X-Response-Time", value: duration)
        
        // 6. Gib die Dauer in der Konsole aus.
        logger.dev("⏱️ Request an '\(request.path)' verarbeitet in \(duration)")

        // 7. Gib die (modifizierte) Antwort zurück.
        return response
    }
}
