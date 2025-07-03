//
//  HttpHeader.swift
//  ZeroHTTP
//
//  Created by Philipp Kotte on 01.07.25.
//

import Foundation

/// A structure that represents a collection of HTTP headers.
///
/// This implementation handles header keys in a case-insensitive manner by
/// normalizing all keys to lowercase for storage and retrieval. It also enforces
/// that both header names and values consist of ASCII characters.
public struct HttpHeaders: ExpressibleByDictionaryLiteral, Equatable {
    public static func == (lhs: HttpHeaders, rhs: HttpHeaders) -> Bool {
        // Check if all lhs entries are in rhs
        for (key, value) in lhs.storage {
            if rhs.storage[key]?.value != value.value {
                return false
            }
        }
        // Check if all rhs entries are in lhs (to ensure no extra entries)
        for (key, value) in rhs.storage {
            if lhs.storage[key]?.value != value.value {
                return false
            }
        }
        return true
    }

    
    /// Internal storage for the headers. The dictionary key is the lowercase
    /// version of the header name for case-insensitive access. The value is a
    /// tuple containing the original key and its value.
    private var storage: [String: (originalKey: String, value: String)] = [:]

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
        precondition(name.utf8.allSatisfy(\.isASCII), "HTTP header name must contain only ASCII characters.")
        precondition(value.utf8.allSatisfy(\.isASCII), "HTTP header value must contain only ASCII characters.")
        
        storage[name.lowercased()] = (originalKey: name, value: value)
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
            return storage[name.lowercased()]?.value
        }
        set {
            if let value = newValue {
                add(name: name, value: value)
            } else {
                remove(name: name)
            }
        }
    }
    
    /// Executes a closure for each header in the collection.
    /// - Parameter body: A closure that takes the original header name and its value as arguments.
    public func forEach(_ body: (String, String) -> Void) {
        storage.values.forEach { body($0.originalKey, $0.value) }
    }
}

extension UInt8 {
    /// A helper property to check if a byte represents an ASCII character.
    fileprivate var isASCII: Bool {
        self <= 127
    }
}

