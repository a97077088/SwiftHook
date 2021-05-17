// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "SwiftHook",
    platforms: [
       .iOS(.v12),
       .macOS(.v10_13),
       .tvOS(.v11),
       .watchOS(.v5)
     ],
    products: [
        .library(name: "SwiftHook", targets: ["SwiftHook"]),
    ],
    targets: [
        .target(name: "SwiftHook"),
        .testTarget(name: "SwiftHookTests", dependencies: ["SwiftHook"]),
    ]
)
