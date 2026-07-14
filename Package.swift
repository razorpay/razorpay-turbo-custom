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
            url: "https://github.com/razorpay/razorpay-turbo-custom/releases/download/2.1.11-beta.1/CommonLibrary.xcframework.zip",
            checksum: "0e15808ac18e403d897f2d08f76cd455eece56c3dbcde2b697e22db9800a2b6c"
        ),
        .binaryTarget(
            name: "two_party",
            url: "https://github.com/razorpay/razorpay-turbo-custom/releases/download/2.1.11-beta.1/two_party.xcframework.zip",
            checksum: "65b4082782fa8a043a474fcd17e989012a1ea6d296b3ca2ae3c5b415996c6469"
        ),
        .binaryTarget(
            name: "RazorpayTurboUPI",
            url: "https://github.com/razorpay/razorpay-turbo-custom/releases/download/2.1.11-beta.3/RazorpayTurboUPI.xcframework.zip",
            checksum: "20288f5eebdb1c2552be5aafd97ed2bfe7a851a4468ec82b90efcd09f35876e5"
        ),
        .binaryTarget(
            name: "TurboUpiPlugin",
            url: "https://github.com/razorpay/razorpay-turbo-custom/releases/download/2.1.11-beta.1/TurboUpiPlugin.xcframework.zip",
            checksum: "ca3f11fa09014a2bcf8797d28bda1054739d400edea2defbca0b0f7c225913b2"
        )
    ]
)
