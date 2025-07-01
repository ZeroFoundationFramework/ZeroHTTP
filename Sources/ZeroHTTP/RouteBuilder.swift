//
//  RouteBuilder.swift
//  zero_proj
//
//  Created by Philipp Kotte on 29.06.25.
//


@resultBuilder
public struct RouteBuilder {
    public static func buildExpression(_ expression: Route) -> [Route] {
        return [expression]
    }

    public static func buildBlock(_ components: [Route]...) -> [Route] {
        return components.flatMap { $0 }
    }
}
