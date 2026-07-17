// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RazorpayTurboCustom",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "RazorpayTurboCustom-Headless",
            targets: [
                "RazorpayTurboCustomDependencies",
                "CommonLibrary",
                "two_party",
                "RazorpayTurboUPI",
                "TurboUpiPlugin"
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/razorpay/razorpay-customui-pod.git", from: "2.2.0")
    ],
    targets: [
        .target(
            name: "RazorpayTurboCustomDependencies",
            dependencies: [
                .product(name: "RazorpayCustomUI", package: "razorpay-customui-pod")
            ],
            path: "Sources/RazorpayTurboCustomDependencies"
        ),
        .binaryTarget(
            name: "CommonLibrary",
            url: "https://github.com/razorpay/razorpay-turbo-custom/releases/download/2.1.11-beta.4/CommonLibrary.xcframework.zip",
            checksum: "a2d16f8cd0ae8d719b85497517d1c133095c1462b5b4ff47fed91e491d0d27a0"
        ),
        .binaryTarget(
            name: "two_party",
            url: "https://github.com/razorpay/razorpay-turbo-custom/releases/download/2.1.11-beta.4/two_party.xcframework.zip",
            checksum: "8b193960c901bb98445b3d9796b0381abc70bbdfaa27f601093ad4679d516583"
        ),
        .binaryTarget(
            name: "RazorpayTurboUPI",
            url: "https://github.com/razorpay/razorpay-turbo-custom/releases/download/2.1.11-beta.4/RazorpayTurboUPI.xcframework.zip",
            checksum: "0610a679385e4819952235b649427eca74ad17460b10ad18815bf4ce0dfc47f6"
        ),
        .binaryTarget(
            name: "TurboUpiPlugin",
            url: "https://github.com/razorpay/razorpay-turbo-custom/releases/download/2.1.11-beta.4/TurboUpiPlugin.xcframework.zip",
            checksum: "a2df69a867437dfbca353f0722677d3312b7d88ba77291b850fc8c2347e649e6"
        )
    ]
)
