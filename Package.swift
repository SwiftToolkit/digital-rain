// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "digital-rain",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [
        .package(url: "https://github.com/mtynior/ColorizeSwift.git", from: "1.7.0")
    ],
    targets: [
        .executableTarget(
            name: "digital-rain",
        dependencies: [
            .product(name: "ColorizeSwift", package: "colorizeswift")
        ]),
    ]
)
