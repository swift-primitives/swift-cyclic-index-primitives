// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "swift-cyclic-index-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "Cyclic Index Primitives",
            targets: ["Cyclic Index Primitives"]
        ),
        .library(
            name: "Cyclic Index Primitives Test Support",
            targets: ["Cyclic Index Primitives Test Support"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-cyclic-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-index-primitives.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Cyclic Index Primitives",
            dependencies: [
                .product(name: "Cyclic Primitives", package: "swift-cyclic-primitives"),
                .product(name: "Index Primitives", package: "swift-index-primitives"),
            ]
        ),
        .target(
            name: "Cyclic Index Primitives Test Support",
            dependencies: [
                "Cyclic Index Primitives",
                .product(name: "Cyclic Primitives Test Support", package: "swift-cyclic-primitives"),
                .product(name: "Index Primitives Test Support", package: "swift-index-primitives"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Cyclic Index Primitives Tests",
            dependencies: [
                "Cyclic Index Primitives",
                "Cyclic Index Primitives Test Support"
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
