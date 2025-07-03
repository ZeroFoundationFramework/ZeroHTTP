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
        .package(url: "https://github.com/ZeroFoundationFramework/ZeroTemplate.git", from: "1.0.4"),
        .package(url: "https://github.com/ZeroFoundationFramework/ZeroErrors.git", from: "1.0.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ZeroHTTP",
            dependencies: [
                .product(name: "ZeroTemplate", package: "ZeroTemplate"),
                .product(name: "ZeroErrors", package: "ZeroErrors")
            ],
        )

    ]
)
