//
//  ZeroHTTP
//  HttpMethod.swift
//
//  Created by Philipp Kotte on 26.06.25.
//

import NIOHTTP1
import Foundation

/// Represents the most common HTTP methods.
///
/// This enum serves as a type-safe abstraction over the HTTP methods
/// provided by SwiftNIO, simplifying their use within the framework.
public enum HttpMethod: String {
    /// The GET method requests a representation of the specified resource.
    /// Requests using GET should only retrieve data.
    case GET
    
    /// The POST method is used to submit an entity to the specified resource,
    /// often causing a change in state or side effects on the server.
    case POST
    
    /// The PUT method replaces all current representations of the target resource
    /// with the request payload.
    case PUT
    
    /// The DELETE method deletes the specified resource.
    case DELETE
    
    /// The PATCH method is used to apply partial modifications to a resource.
    case PATCH

    /// Initializes an `HttpMethod` instance from an `NIOHTTP1.HTTPMethod`.
    ///
    /// This failable initializer acts as a bridge between the low-level NIO layer
    /// and the framework's abstraction layer.
    ///
    /// - Parameters:
    ///   - nioMethod: The `NIOHTTP1.HTTPMethod` instance to be converted.
    /// - Returns: A corresponding `HttpMethod` instance, or `nil` if the method is not supported.
    public init?(_ nioMethod: NIOHTTP1.HTTPMethod) {
        switch nioMethod {
        case .GET: self = .GET
        case .POST: self = .POST
        case .PUT: self = .PUT
        case .DELETE: self = .DELETE
        case .PATCH: self = .PATCH
        default: return nil
        }
    }
}
