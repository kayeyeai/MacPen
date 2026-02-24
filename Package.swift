// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "MacPen",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        .executableTarget(
            name: "MacPen",
            path: "Sources/MacPen",
            resources: [
                .copy("Resources/AppIcon.svg")
            ]
        )
    ]
)
