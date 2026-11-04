// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MatchedGeometryTransition",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "MatchedGeometryTransition",
            targets: ["MatchedGeometryTransition"]
        )
    ],
    targets: [
        .target(name: "MatchedGeometryTransition"),
        .testTarget(
            name: "MatchedGeometryTransitionTests",
            dependencies: ["MatchedGeometryTransition"]
        )
    ]
)
