//
//  HttpRequest.swift
//  zero_proj
//
//  Created by Philipp Kotte on 29.06.25.
//
import Foundation

public struct HttpRequest {
    public let method: HttpMethod
    public let path: String
    public let headers: [String: String]
    public let body: Data?
    
    public init(
        method: HttpMethod,
        path: String,
        headers: [String: String] = [:],
        body: Data? = nil
    ) {
        self.method = method
        self.path = path
        self.headers = headers
        self.body = body
    }
}
