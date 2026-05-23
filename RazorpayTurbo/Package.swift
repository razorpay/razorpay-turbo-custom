// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RazorpayTurbo",
    products: [
        .library(
            name: "RazorpayTurbo",
            targets: ["RazorpayTurbo"])
    ],
    targets: [
        
        .target(
            name: "RazorpayTurbo",
            dependencies: [
                "RazorpayTurboUPI",
                "TurboUpiPlugin",
                "two_party",
                "CommonLibrary",
                "Razorpay",
                "Sentry"
            ]
        ),
        .binaryTarget(
            name: "RazorpayTurboUPI",
            path: "Sources/DependentFrameworks/RazorpayTurboUPI.xcframework"
        ),
        .binaryTarget(
            name: "TurboUpiPlugin",
            path: "Sources/DependentFrameworks/TurboUpiPlugin.xcframework"
        ),
        .binaryTarget(
            name: "two_party",
            path: "Sources/DependentFrameworks/two_party.xcframework"
        ),
        .binaryTarget(
            name: "CommonLibrary",
            path: "Sources/DependentFrameworks/CommonLibrary.xcframework"
        ),
        .binaryTarget(
            name: "Razorpay",
            path: "Sources/DependentFrameworks/Razorpay.xcframework"
        ),
        .binaryTarget(
            name: "Sentry",
            path: "Sources/DependentFrameworks/Sentry.xcframework"
        ),
    ]
)
