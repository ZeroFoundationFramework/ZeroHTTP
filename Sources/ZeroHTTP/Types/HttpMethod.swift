//
//  ZeroHTTP
//  HttpMethod.swift
//
//  Created by Philipp Kotte on 26.06.25.
//

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
    
    case UNKNOWN
}
