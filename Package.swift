// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ProZKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ProZKit",
            targets: ["ProZKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/omise/omise-ios.git", exact: "5.3.0"),
//        .package(url: "https://github.com/AgoraIO/AgoraRtcEngine_iOS.git", exact: "4.5.0"),
    ],
    targets: [
        .binaryTarget(
            name: "MobileRTC",
            url: "https://caswebsupport.blob.core.windows.net/mobilesdk/MobileRTC.xcframework.zip",
            checksum: "7b267dce98a2c61a249c95c6cdcaff664db4453e25de7be049094dd6deb89e92"
        ),
        .target(
            name: "ProZKit",
            dependencies: [
                "MobileRTC",
                .product(name: "OmiseSDK", package: "omise-ios"),
//                .product(name: "AgoraRtcKit", package: "AgoraInfra_iOS")
            ],
            resources: [
                .copy("Resources/MobileRTCResources.bundle")
            ]
        ),
        .testTarget(
            name: "ProZKitTests",
            dependencies: ["ProZKit"]
        )
    ]
)
