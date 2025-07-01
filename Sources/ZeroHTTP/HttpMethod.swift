//
//  RouteMethod.swift
//  Zero
//
//  Created by Philipp Kotte on 26.06.25.
//
//test
import NIOHTTP1
import Foundation

public enum HttpMethod: String {
    case GET, POST, PUT, DELETE, PATCH

    /// Initializer, um eine NIOHTTP1.HTTPMethod in unsere eigene umzuwandeln.
    /// Das ist die "Brücke" zwischen NIO und unserem Router.
    public init?(_ nioMethod: HTTPMethod) {
        switch nioMethod {
        case .GET: self = .GET
        case .POST: self = .POST
        case .PUT: self = .PUT
        case .DELETE: self = .DELETE
        case .PATCH: self = .PATCH
        default: return nil // Andere Methoden unterstützen wir hier nicht
        }
    }
}
