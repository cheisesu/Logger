// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Logger",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13)
    ],
    products: [
        .executable(name: "Example", targets: ["Example"]),
        .library(
            name: "Logger",
            targets: ["Logger"])
    ],
    targets: [
        .target(
            name: "Logger",
            dependencies: [],
            swiftSettings: [
                .swiftLanguageVersion(.v5),
            ]
        ),
        .executableTarget(
            name: "Example",
            dependencies: ["Logger"],
            swiftSettings: [
                .swiftLanguageVersion(.v5),
            ]
        ),
        .testTarget(
            name: "LoggerTests",
            dependencies: ["Logger"],
            swiftSettings: [
                .swiftLanguageVersion(.v5),
            ]
        ),
    ]
)
