// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AlphaSwiftage",
    platforms: [.iOS(.v13), .macOS(.v10_15), .watchOS(.v6), .tvOS(.v13)],
    products: [
        .library(
            name: "AlphaSwiftage",
            targets: ["AlphaSwiftage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.0")),
        .package(url: "https://github.com/WeTransfer/Mocker.git", .upToNextMajor(from: "3.0.0"))
    ],
    targets: [
        .target(
            name: "AlphaSwiftage",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire")
            ]),
        .testTarget(
            name: "AlphaSwiftageTests",
            dependencies: ["AlphaSwiftage", "Mocker"],
            path: "Tests",
            resources: [ .copy("Resources")]),
    ]
)
