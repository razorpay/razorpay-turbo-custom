// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RazorpayTurboCustom",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "RazorpayTurboCustom-Headless",
            targets: [
                "CommonLibrary",
                "two_party",
                "RazorpayTurboUPI",
                "TurboUpiPlugin"
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/razorpay/razorpay-customui-pod.git")
    ],
    targets: [
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
            url: "https://github.com/razorpay/razorpay-turbo-custom/releases/download/2.1.11-beta.1/RazorpayTurboUPI.xcframework.zip",
            checksum: "0509d1c9242bc7661e19522f3d6a715ac715f187fdb463069c8ab8a05f435205"
        ),
        .binaryTarget(
            name: "TurboUpiPlugin",
            url: "https://github.com/razorpay/razorpay-turbo-custom/releases/download/2.1.11-beta.1/TurboUpiPlugin.xcframework.zip",
            checksum: "ca3f11fa09014a2bcf8797d28bda1054739d400edea2defbca0b0f7c225913b2"
        )
    ]
)
