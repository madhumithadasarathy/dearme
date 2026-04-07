// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DearMe",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "DearMe", targets: ["DearMe"])
    ],
    targets: [
        .target(
            name: "DearMe",
            path: "DearMe"
        )
    ]
)
