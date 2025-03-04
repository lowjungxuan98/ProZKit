// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "ProZKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ProZKit",
            targets: ["ProZKit"]
        )
    ],
    targets: [
        // Binary target for the MobileRTC.xcframework zipped file.
        .binaryTarget(
            name: "MobileRTC",
            url: "https://caswebsupport.blob.core.windows.net/mobilesdk/MobileRTC.xcframework.zip",
            checksum: "7b267dce98a2c61a249c95c6cdcaff664db4453e25de7be049094dd6deb89e92"
        ),
        // Wrapper target that depends on the MobileRTC binary target and includes the resource bundle.
        .target(
            name: "ProZKit",
            dependencies: ["MobileRTC"],
            resources: [
                // Make sure you place MobileRTCResources.bundle inside a "Resources" folder at the package root.
//                .copy("Resources/MobileRTCResources.bundle")
//                .process("Resources")
                .copy("Resources/MobileRTCResources.bundle")
            ]
        ),
        .testTarget(
            name: "ProZKitTests",
            dependencies: ["ProZKit"]
        )
    ]
)
