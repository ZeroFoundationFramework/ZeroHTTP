//
//  ZeroHTTP
//  HttpResponse.swift
//
//  Created by Philipp Kotte on 29.06.25.
//

import Foundation
import ZeroTemplate

/// Represents an outgoing HTTP response.
///
/// This struct encapsulates all necessary components for an HTTP response,
/// including the status code, headers, and the response body.
public struct HttpResponse {
    /// The HTTP status code of the response (e.g., `.ok`, `.notFound`).
    public let status: HttpResponseStatus
    
    /// The HTTP headers to be sent with the response.
    public var headers: HttpHeaders
    
    /// The body of the response as a `String`.
    public let body: Data?
    
    public var statusPhrase: String = ""

    /// Initializes a new `HttpResponse` for plain text content.
    ///
    /// This initializer defaults to a `200 OK` status and sets the
    /// `Content-Type` header to `text/plain`.
    ///
    /// - Parameters:
    ///   - status: The HTTP status for the response. Defaults to `.ok`.
    ///   - body: The string content of the response body.
    @available(*, deprecated, message: "Use the Data initializer instead.")
    public init(status: HttpResponseStatus = .ok, body: String = "") {
        self.status = status
        self.body = body.data(using: .utf8)!
        self.headers = HttpHeaders()
        self.headers.add(name: "Content-Type", value: "text/plain; charset=utf-8")
    }
    
    public init(status: HttpResponseStatus, statusPhrase: String, headers: HttpHeaders = .init(), body: Data? = nil){
        self.status = status
        self.statusPhrase = statusPhrase
        self.headers = headers
        self.body = body
    }
    
    /// Initializes a new `HttpResponse` for plain text content.
    ///
    /// This initializer defaults to a `200 OK` status and sets the
    /// `Content-Type` header to `text/plain`.
    ///
    /// - Parameters:
    ///   - status: The HTTP status for the response. Defaults to `.ok`.
    ///   - body: The string content of the response body.
    public init(status: HttpResponseStatus = .ok, body: Data){
        self.status = status
        self.body = body
        self.headers = HttpHeaders()
    }

    /// Initializes a new `HttpResponse` with custom headers.
    ///
    /// - Parameters:
    ///   - status: The HTTP status for the response.
    ///   - headers: A dictionary of `HTTPHeaders` for the response.
    ///   - body: The string content of the response body.
    @available(*, deprecated, message: "Use the Initializer that takes data instead of String for the Body.")
    public init(status: HttpResponseStatus, headers: HttpHeaders, body: String = "") {
        self.status = status
        self.headers = headers
        self.body = body.data(using: .utf8)!
    }
    
    /// Initializes a new `HttpResponse` with custom headers.
    ///
    /// - Parameters:
    ///   - status: The HTTP status for the response.
    ///   - headers: A dictionary of `HTTPHeaders` for the response.
    ///   - body: The string content of the response body.
    public init(status: HttpResponseStatus, headers: HttpHeaders, body: Data) {
        self.status = status
        self.headers = headers
        self.body = body
    }
}
