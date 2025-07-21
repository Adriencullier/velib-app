// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StationFinder",
    platforms: [.iOS(.v15)],
    products: [
        // Domain
        .library(
            name: "StationFinderDomain",
            targets: ["StationFinderDomain"]
        ),
        // Data
        .library(
            name: "StationFinderData",
            targets: ["StationFinderData"]
        ),
        // Presentation
        .library(
            name: "StationFinderPresentation",
            targets: ["StationFinderPresentation"]
        ),
        // Module configuration
        .library(
            name: "StationFinderModuleConfiguration",
            targets: ["StationFinderModuleConfiguration"]
        ),
    ],
    dependencies: [
        .package(
            name: "Shared",
            path: "../Shared"
        )
    ],
    targets: [
        // Domain
        .target(
            name: "StationFinderDomain"
        ),
        .testTarget(
            name: "StationFinderDomainTests",
            dependencies: ["StationFinderDomain"]
        ),
        // Data
        .target(
            name: "StationFinderData",
            dependencies: [
                "StationFinderDomain",
                .product(
                    name: "CoreNetworking",
                    package: "Shared"
                ),
            ]
        ),
        .testTarget(
            name: "StationFinderDataTests",
            dependencies: ["StationFinderData"]
        ),
        // Presentation
        .target(
            name: "StationFinderPresentation",
            dependencies: [
                "StationFinderDomain"
            ]
        ),
        .testTarget(
            name: "StationFinderPresentationTests",
            dependencies: ["StationFinderPresentation"]
        ),
        // Module configuration
        .target(
            name: "StationFinderModuleConfiguration",
            dependencies: [
                "StationFinderDomain",
                "StationFinderData",
                .product(
                    name: "DependencyInjection",
                    package: "Shared"
                ),
            ]
        ),
        .testTarget(
            name: "StationFinderModuleConfigurationTests",
            dependencies: ["StationFinderModuleConfiguration"]
        ),
    ]
)
