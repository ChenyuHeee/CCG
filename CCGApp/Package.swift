// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CCGApp",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "CCGApp",
            targets: ["CCGApp"])
    ],
    dependencies: [
        // Markdown rendering
        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", from: "2.3.0")
    ],
    targets: [
        .target(
            name: "CCGApp",
            dependencies: [
                .product(name: "MarkdownUI", package: "swift-markdown-ui")
            ],
            path: "CCGApp"
        )
    ]
)
