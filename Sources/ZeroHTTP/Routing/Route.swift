//
//  ZeroHTTP
//  Route.swift
//
//  Created by Philipp Kotte on 29.06.25.
//

import Foundation

/// A type alias for a closure that handles an `HttpRequest` and returns an `HttpResponse`.
public typealias RouteHandler = (HttpRequest) -> HttpResponse

/// Represents a single endpoint in the router.
///
/// Each route maps a specific HTTP method and path to a handler closure
/// that processes the request.
public struct Route: Metadatable {
    /// The HTTP method this route responds to (e.g., GET, POST).
    public let method: HttpMethod
    
    /// The URL path this route matches (e.g., "/users", "/products/:id").
    public let path: String
    
    /// The closure that is executed when this route is matched.
    public let handler: RouteHandler
    
    public var metadata: [String: Any] = [:]
    
    /// Initializes a new `Route`.
    ///
    /// - Parameters:
    ///   - method: The `HttpMethod` for the route.
    ///   - path: The URL path to match.
    ///   - handler: The closure to execute for this route. It is marked as `@escaping`
    ///              because it is stored to be called later by the router.
    public init(method: HttpMethod, path: String, handler: @escaping RouteHandler) {
        self.method = method
        self.path = path
        self.handler = handler
    }
    
    /// Eine generische Methode, um beliebige Metadaten zu einer Route hinzuzufügen.
    public func metadata(_ key: String, _ value: Any) -> Route {
        var newRoute = self
        newRoute.metadata[key] = value
        return newRoute
    }
    
    
    /// Erstellt eine neue GET-Route.
    public static func get(_ path: String, handler: @escaping RouteHandler) -> Route {
        return Route(method: .GET, path: path, handler: handler)
    }
    
    /// Erstellt eine neue POST-Route.
    public static func post(_ path: String, handler: @escaping RouteHandler) -> Route {
        return Route(method: .POST, path: path, handler: handler)
    }
    
    /// Erstellt eine neue PUT-Route.
    public static func put(_ path: String, handler: @escaping RouteHandler) -> Route {
        return Route(method: .PUT, path: path, handler: handler)
    }
    
    /// Erstellt eine neue DELETE-Route.
    public static func delete(_ path: String, handler: @escaping RouteHandler) -> Route {
        return Route(method: .DELETE, path: path, handler: handler)
    }
}

