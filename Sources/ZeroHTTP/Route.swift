//
//  Route.swift
//  zero_proj
//
//  Created by Philipp Kotte on 29.06.25.
//

public typealias RouteHandler = (HttpRequest) -> HttpResponse

public struct Route {
    public let method: HttpMethod
    public let path: String
    public let handler: RouteHandler

    public init(method: HttpMethod, path: String, handler: @escaping RouteHandler) {
        self.method = method
        self.path = path
        self.handler = handler
    }
}
