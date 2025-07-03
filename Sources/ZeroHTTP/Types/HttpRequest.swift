//
//  ZeroHTTP
//  HttpRequest.swift
//
//  Created by Philipp Kotte on 29.06.25.
//
import Foundation

/// Represents an incoming HTTP request within the framework.
///
/// This struct encapsulates all relevant information of a request,
/// such as the HTTP method, path, and headers, into a single,
/// easy-to-handle object.
public struct HttpRequest {
    /// The HTTP method of the request (e.g., GET, POST).
    public let method: HttpMethod
    
    /// The requested URL path (e.g., "/users/profile").
    public let path: String
    
    /// A dictionary containing the HTTP headers of the request.
    public let headers: HttpHeaders
    
    /// The optional body of the request, typically for POST or PUT requests.
    public let body: Data?
    
    /// Initializes a new `HttpRequest` instance.
    ///
    /// - Parameters:
    ///   - method: The `HttpMethod` of the request.
    ///   - path: The requested URL path.
    ///   - headers: A dictionary containing the request headers. Defaults to an empty dictionary.
    ///   - body: The optional body of the request as `Data`. Defaults to `nil`.
    public init(
        method: HttpMethod,
        path: String,
        headers: HttpHeaders = [:],
        body: Data? = nil
    ) {
        self.method = method
        self.path = path
        self.headers = headers
        self.body = body
    }
}
