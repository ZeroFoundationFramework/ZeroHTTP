//
//  Server.swift
//  zero_proj
//
//  Created by Philipp Kotte on 03.07.25.
//

import Foundation
import Network
import ZeroLogger

public final class Server: @unchecked Sendable{
    private let listener: NWListener
    private let router: @Sendable (HttpRequest) -> HttpResponse
    private var middleware: [Middleware]
    private var logger = Logger(label: "zero.http.server")
    
    public init(port: UInt16, middlewares: [Middleware] = [], router: @escaping @Sendable (HttpRequest) -> HttpResponse) throws {
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
            switch state {
            case .ready:
                if let port = self.listener.port {
                    self.logger.info("✅ Server lauscht auf Port \(port)")
                }
            case .failed(let error):
                self.logger.info("❌ Serverstart fehlgeschlagen: \(error.localizedDescription)")
            default:
                break
            }
        }
        
        listener.newConnectionHandler = { [weak self] newConnection in
            guard let self = self else { return }
            let handler = ConnectionHandler(connection: newConnection, middlewares: self.middleware, router: self.router)
            handler.start()
        }
        
        listener.start(queue: .global())
        self.logger.info("✅ Server lauscht auf Port \(listener.port!)")
    }
    
    
    public func stop(){
        listener.cancel()
    }
}
