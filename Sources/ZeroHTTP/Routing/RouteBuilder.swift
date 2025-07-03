//
//  RouteBuilder.swift
//
//  Created by Philipp Kotte on 29.06.25.
//

/// A result builder that allows for a declarative, SwiftUI-like syntax
/// for defining a collection of `Route` instances.
@resultBuilder
public struct RouteBuilder {
    /// Processes a single `Route` expression within the builder block.
    public static func buildExpression(_ expression: Route) -> [Route] {
        return [expression]
    }

    /// Combines multiple arrays of `Route`s into a single array.
    /// This is the core function that allows listing multiple routes in a block.
    public static func buildBlock(_ components: [Route]...) -> [Route] {
        return components.flatMap { $0 }
    }
}
