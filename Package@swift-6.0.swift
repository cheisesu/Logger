// swift-tools-version: 6.0

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
                .swiftLanguageMode(.v6)
            ]
        ),
        .executableTarget(
            name: "Example",
            dependencies: ["Logger"],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .testTarget(
            name: "LoggerTests",
            dependencies: ["Logger"],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]),
    ]
)
