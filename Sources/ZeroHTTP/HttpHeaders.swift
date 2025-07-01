//
//  HttpHeader.swift
//  ZeroHTTP
//
//  Created by Philipp Kotte on 01.07.25.
//

import Foundation

/// A structure that represents a collection of HTTP headers.
///
/// This implementation handles header keys in a case-insensitive manner,
/// as required by the HTTP specification. It provides an easy-to-use,
/// dictionary-like interface for managing headers.
public struct HttpHeaders {

    /// Internal storage for the headers. The keys are normalized to lowercase
    /// to ensure case-insensitivity, while the original casing of the key is preserved.
    private var storage: [String: (originalKey: String, value: String)] = [:]

    /// An array of all header names in their original casing.
    public var names: [String] {
        return storage.values.map { $0.originalKey }
    }

    /// Initializes an empty `HttpHeaders` collection.
    public init() {}

    /// Initializes `HttpHeaders` from a dictionary.
    /// - Parameter dictionary: A dictionary of header key-value pairs.
    public init(_ dictionary: [String: String]) {
        for (key, value) in dictionary {
            self.add(name: key, value: value)
        }
    }

    /// Adds a new header or updates an existing one.
    ///
    /// If a header with the same name (case-insensitive) already exists,
    /// its value will be replaced with the new value.
    ///
    /// - Parameters:
    ///   - name: The name of the header (e.g., "Content-Type").
    ///   - value: The value of the header.
    public mutating func add(name: String, value: String) {
        let normalizedKey = name.lowercased()
        storage[normalizedKey] = (originalKey: name, value: value)
    }

    /// Removes a header by its name.
    ///
    /// - Parameter name: The case-insensitive name of the header to remove.
    public mutating func remove(name: String) {
        let normalizedKey = name.lowercased()
        storage[normalizedKey] = nil
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
}

