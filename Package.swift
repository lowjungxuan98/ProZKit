// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ProZKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "ProZKit",
            targets: ["ProZKit"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/omise/omise-ios.git",
            exact: "5.3.0"
        ),
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            exact: "11.9.0"
        ),
        .package(
            url: "https://github.com/AgoraIO/AgoraRtcEngine_iOS",
            exact: "4.5.1"
        ),
        .package(
            url: "https://github.com/nicklockwood/SwiftFormat",
            from: "0.55.0"
        ),
        .package(
            url: "https://github.com/patchthecode/JTAppleCalendar.git",
            from: "8.0.5"
        ),
        .package(
            url: "https://github.com/hackiftekhar/IQKeyboardManager.git",
            from: "8.0.0"
        ),
    ],
    targets: [
        .binaryTarget(
            name: "MobileRTC",
            url: "https://caswebsupport.blob.core.windows.net/mobilesdk/MobileRTC.xcframework.zip",
            checksum: "7b267dce98a2c61a249c95c6cdcaff664db4453e25de7be049094dd6deb89e92"
        ),
        .target(
            name: "IoniconsSwift",
            dependencies: [],
            resources: [
                // Processes all resources in the Resources folder.
                .process("Resources"),
            ]
        ),
        .target(
            name: "ProZKit",
            dependencies: [
                "MobileRTC",
                "JTAppleCalendar",
                "IoniconsSwift",
                .product(name: "OmiseSDK", package: "omise-ios"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
                .product(name: "FirebaseDynamicLinks", package: "firebase-ios-sdk"),
                // Agora products
                .product(name: "RtcBasic", package: "AgoraRtcEngine_iOS"),
                .product(name: "AINS", package: "AgoraRtcEngine_iOS"),
                .product(name: "AINSLL", package: "AgoraRtcEngine_iOS"),
                .product(name: "AudioBeauty", package: "AgoraRtcEngine_iOS"),
                .product(name: "ClearVision", package: "AgoraRtcEngine_iOS"),
                .product(name: "ContentInspect", package: "AgoraRtcEngine_iOS"),
                .product(name: "SpatialAudio", package: "AgoraRtcEngine_iOS"),
                .product(name: "VirtualBackground", package: "AgoraRtcEngine_iOS"),
                .product(name: "AIAEC", package: "AgoraRtcEngine_iOS"),
                .product(name: "AIAECLL", package: "AgoraRtcEngine_iOS"),
                .product(name: "VQA", package: "AgoraRtcEngine_iOS"),
                .product(name: "FaceDetection", package: "AgoraRtcEngine_iOS"),
                .product(name: "FaceCapture", package: "AgoraRtcEngine_iOS"),
                .product(name: "LipSync", package: "AgoraRtcEngine_iOS"),
                .product(name: "VideoCodecEnc", package: "AgoraRtcEngine_iOS"),
                .product(name: "VideoCodecDec", package: "AgoraRtcEngine_iOS"),
                .product(name: "VideoAv1CodecEnc", package: "AgoraRtcEngine_iOS"),
                .product(name: "VideoAv1CodecDec", package: "AgoraRtcEngine_iOS"),
                .product(name: "ReplayKit", package: "AgoraRtcEngine_iOS"),
                // IQKeyboardManagerSwift
                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
            ],
            resources: [
                .copy("Resources/MobileRTCResources.bundle"),
            ]
        ),
    ]
)
