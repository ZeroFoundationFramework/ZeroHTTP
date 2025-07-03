//
//  Server.swift
//  zero_proj
//
//  Created by Philipp Kotte on 03.07.25.
//

import Foundation
import Network

public final class Server: @unchecked Sendable{
    private let listener: NWListener
    private let router: @Sendable (HttpRequest) -> HttpResponse
    private var middleware: [Middleware]
    
    public init(port: UInt16, router: @escaping @Sendable (HttpRequest) -> HttpResponse, middlewares: [Middleware] = []) throws {
        self.router = router
        let parameters = NWParameters.tcp
        self.listener = try NWListener(using: parameters, on: .init(integerLiteral: port))
        self.middleware = middlewares
    }
    
    public func addMiddleware(_ middleware: Middleware){
        self.middleware.append(middleware)
    }
    
    public func middlewareSize() -> Int {
        return self.middleware.count
    }
    
    public func start() throws {
        listener.stateUpdateHandler = { state in
            // Server status änderungen behandeln
        }
        
        listener.newConnectionHandler = { [weak self] newConnection in
            guard let self = self else { return }
            let handler = ConnectionHandler(connection: newConnection, router: self.router)
            handler.start()
        }
        
        listener.start(queue: .global())
        
        print("✅ Server lauscht auf Port \(listener.port!)")
    }
    
    
    public func stop(){
        listener.cancel()
    }
}
