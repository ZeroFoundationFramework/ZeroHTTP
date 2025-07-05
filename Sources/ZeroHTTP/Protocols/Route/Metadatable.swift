//
//  Metadatable.swift
//  zero_proj
//
//  Created by Philipp Kotte on 05.07.25.
//


/// Ein Protokoll für Typen, die einen flexiblen Metadaten-Container bereitstellen.
public protocol Metadatable {
    var metadata: [String: Any] { get set }
}
