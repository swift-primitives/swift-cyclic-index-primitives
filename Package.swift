// swift-tools-version: 6.2

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
        .package(path: "../swift-cyclic-primitives"),
        .package(path: "../swift-index-primitives"),
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
    let settings: [SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableExperimentalFeature("Lifetimes"),
        .strictMemorySafety()
    ]
    target.swiftSettings = (target.swiftSettings ?? []) + settings
}
