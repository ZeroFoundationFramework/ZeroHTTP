//
//  HttpRequest.swift
//  zero_proj
//
//  Created by Philipp Kotte on 29.06.25.
//
import Foundation

public struct HttpRequest {
    let method: HttpMethod
    let path: String
    let headers: [String: String]
    let body: Data?
}
