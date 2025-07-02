//
//  HttpHeader.swift
//  ZeroHTTP
//
//  Created by Philipp Kotte on 01.07.25.
//

import Foundation
import NIOHTTP1

/// A structure that represents a collection of HTTP headers.
///
/// This implementation handles header keys in a case-insensitive manner by
/// normalizing all keys to lowercase for storage and retrieval. It also enforces
/// that both header names and values consist of ASCII characters.
public struct HttpHeaders: ExpressibleByDictionaryLiteral, Equatable {
    
    

    /// Internal storage for the headers. Keys are always stored in lowercase.
    private var storage: [String: String] = [:]

    /// Initializes an empty `HttpHeaders` collection.
    public init() {}

    /// Initializes `HttpHeaders` from a dictionary.
    /// - Parameter dictionary: A dictionary of header key-value pairs.
    public init(_ dictionary: [String: String]) {
        for (key, value) in dictionary {
            self.add(name: key, value: value)
        }
    }
    
    /// Initializes `HttpHeaders` from a dictionary literal (e.g., `[:]` or `["Content-Type": "application/json"]`).
    public init(dictionaryLiteral elements: (String, String)...) {
        for (key, value) in elements {
            self.add(name: key, value: value)
        }
    }

    /// Adds a new header or updates an existing one.
    ///
    /// The header name is treated as case-insensitive. This method will trigger
    /// a precondition failure if the name or value contain non-ASCII characters.
    ///
    /// - Parameters:
    ///   - name: The name of the header (e.g., "Content-Type"). Must be ASCII.
    ///   - value: The value of the header. Must be ASCII.
    public mutating func add(name: String, value: String) {
        // HIER IST DIE ÄNDERUNG:
        // Erzwinge, dass Header-Namen und -Werte ASCII-konform sind.
        precondition(!name.utf8.contains(where: { !$0.isASCII }), "HTTP header name must contain only ASCII characters.")
        precondition(!value.utf8.contains(where: { !$0.isASCII }), "HTTP header value must contain only ASCII characters.")
        
        storage[name.lowercased()] = value
    }

    /// Removes a header by its name.
    ///
    /// - Parameter name: The case-insensitive name of the header to remove.
    public mutating func remove(name: String) {
        storage[name.lowercased()] = nil
    }

    /// Checks if a header with the given name exists.
    ///
    /// - Parameter name: The case-insensitive name of the header.
    /// - Returns: `true` if the header exists, otherwise `false`.
    public func contains(name: String) -> Bool {
        return storage[name.lowercased()] != nil
    }

    /// Accesses the value of a header using a subscript.
    ///
    /// Example:
    /// ```
    /// var headers = HttpHeaders()
    /// headers["Content-Type"] = "application/json"
    /// print(headers["content-type"]) // Optional("application/json")
    /// ```
    public subscript(name: String) -> String? {
        get {
            return storage[name.lowercased()]
        }
        set {
            if let value = newValue {
                add(name: name, value: value)
            } else {
                remove(name: name)
            }
        }
    }
    
    func toNIOHeaders() -> NIOHTTP1.HTTPHeaders {
        var nioHeaders = NIOHTTP1.HTTPHeaders()
        // Annahme: Deine interne Speicherung heißt `storage`
        for (key, value) in storage {
            nioHeaders.add(name: key, value: value)
        }
        return nioHeaders
    }
}

extension UInt8 {
    fileprivate var isASCII: Bool {
        self <= 127
    }
}

