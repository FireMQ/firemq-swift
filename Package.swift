// swift-tools-version:5.9
//
// FireMQ for Swift: UniFFI bindings over the Rust client of the FireMQ message broker.
//
// FireMQFFI is the Rust library, prebuilt as an XCFramework for macOS, iOS and the iOS
// simulator by each FireMQ release. scripts/update.sh points this file at a release.

import PackageDescription

let package = Package(
    name: "FireMQ",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        .library(name: "FireMQ", targets: ["FireMQ"])
    ],
    targets: [
        .binaryTarget(
            name: "FireMQFFI",
            url: "https://github.com/FireMQ/firemq/releases/download/v0.1.0/FireMQFFI.xcframework.zip",
            checksum: "77eff2b779f835fb9af6ff87c8bcbfb421c6b9a2321325a73e21bc13ae98cd53"
        ),
        .target(
            name: "FireMQ",
            dependencies: ["FireMQFFI"],
            path: "Sources/FireMQ"
        ),
        .executableTarget(
            name: "HelloFireMQ", dependencies: ["FireMQ"], path: "Examples/HelloFireMQ"),
    ]
)
