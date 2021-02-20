// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SQDifferenceKit",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "SQDifferenceKit",
            targets: ["SQDifferenceKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ra1028/DifferenceKit.git", from: "1.1.5")
    ],
    targets: [
        .target(
            name: "SQDifferenceKit",
            dependencies: []),
        .testTarget(
            name: "SQDifferenceKitTests",
            dependencies: ["SQDifferenceKit"]),
    ]
)
