// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZeroHTTP",
    platforms: [.macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ZeroHTTP",
            targets: ["ZeroHTTP"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/ZeroFoundationFramework/ZeroTemplate.git", from: "1.0.7"),
        .package(url: "https://github.com/ZeroFoundationFramework/ZeroErrors.git", from: "1.0.2"),
        .package(url: "https://github.com/ZeroFoundationFramework/ZeroLogger.git", from: "1.0.1"),
        .package(url: "https://github.com/ZeroFoundationFramework/ZeroDI.git", from: "1.0.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ZeroHTTP",
            dependencies: [
                .product(name: "ZeroTemplate", package: "ZeroTemplate"),
                .product(name: "ZeroErrors", package: "ZeroErrors"),
                .product(name: "ZeroLogger", package: "ZeroLogger"),
                .product(name: "ZeroDI", package: "ZeroDI")
            ],
        )

    ]
)
