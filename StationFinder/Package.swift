// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StationFinder",
    platforms: [.iOS(.v18)],
    products: [
        // Framework
        .library(
            name: "StationFinderFramework",
            targets: ["StationFinderFramework"]
        ),
        // Data
        .library(
            name: "StationFinderData",
            targets: ["StationFinderData"]
        ),
        // Domain
        .library(
            name: "StationFinderDomain",
            targets: ["StationFinderDomain"]
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
        // Framework
        .target(
            name: "StationFinderFramework",
            dependencies: [
                "StationFinderData",
                .product(
                    name: "CoreNetworking",
                    package: "Shared"
                ),
            ]
        ),
        .testTarget(
            name: "StationFinderFrameworkTests",
            dependencies: ["StationFinderFramework"]
        ),
        // Data
        .target(
            name: "StationFinderData",
            dependencies: [
                "StationFinderDomain",
                .product(
                    name: "Utilities",
                    package: "Shared"
                ),
            ]
        ),
        .testTarget(
            name: "StationFinderDataTests",
            dependencies: ["StationFinderData"]
        ),
        // Domain
        .target(
            name: "StationFinderDomain"
        ),
        .testTarget(
            name: "StationFinderDomainTests",
            dependencies: ["StationFinderDomain"]
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
                "StationFinderFramework",
                .product(
                    name: "DependencyInjection",
                    package: "Shared"
                ),
                .product(
                    name: "Utilities",
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
