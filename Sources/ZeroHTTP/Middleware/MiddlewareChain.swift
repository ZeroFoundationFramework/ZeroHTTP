//
//  MiddlewareChain.swift
//  ZeroHTTP
//
//  Created by Philipp Kotte on 03.07.25.
//

import Foundation

/// Führt eine Kette von Middlewares aus.
struct MiddlewareChain {
    private let middlewares: [Middleware]
    private let finalResponder: Responder

    init(middlewares: [Middleware], responder: @escaping Responder) {
        self.middlewares = middlewares
        self.finalResponder = responder
    }

    /// Startet die Ausführung der Middleware-Kette.
    func run(request: HttpRequest) -> HttpResponse {
        // Erstelle eine rekursive Closure, die die Kette durchläuft.
        func next(index: Int, request: HttpRequest) -> HttpResponse {
            // Wenn wir am Ende der Kette sind, rufe den finalen Responder (den Router) auf.
            guard index < middlewares.count else {
                return finalResponder(request)
            }
            
            // Rufe die aktuelle Middleware auf und übergebe ihr die `next`-Closure für die nächste Ebene.
            return middlewares[index].handle(request: request) { req in
                return next(index: index + 1, request: req)
            }
        }
        
        return next(index: 0, request: request)
    }
}
