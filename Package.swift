// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "UserDefaults++",
	platforms: [
		.iOS(.v8)
	],
    products: [
        .library(
            name: "UserDefaultsPlusPlus",
            targets: ["UserDefaultsPlusPlus"]
        )
    ],
    targets: [
        .target(
            name: "UserDefaultsPlusPlus",
		path: "UserDefaultsPlusPlus"
        )
    ]
)
