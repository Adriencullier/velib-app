// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Shared",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "CoreNetworking",
            targets: ["CoreNetworking"]
        ),
        .library(
            name: "DependencyInjection",
            targets: ["DependencyInjection"]
        ),
        .library(
            name: "Utilities",
            targets: ["Utilities"]
        ),
    ],
    targets: [
        .target(
            name: "CoreNetworking",
            dependencies: [
                "DependencyInjection"
            ]
        ),
        .testTarget(
            name: "CoreNetworkingTests",
            dependencies: ["CoreNetworking"]
        ),
        .target(
            name: "DependencyInjection"
        ),
        .testTarget(
            name: "DependencyInjectionTests",
            dependencies: ["DependencyInjection"]
        ),
        .target(
            name: "Utilities",
        ),
        .testTarget(
            name: "UtilitiesTests",
            dependencies: ["Utilities"]
        ),
    ]
)
