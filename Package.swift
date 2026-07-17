// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ProcessSim",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "ProcessSim",
            targets: ["ProcessSim"]
        ),
        .executable(
            name: "process-sim",
            targets: ["ProcessSimCLI"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ProcessSim",
            dependencies: [],
            path: "Sources/ProcessSim"
        ),
        .executableTarget(
            name: "ProcessSimCLI",
            dependencies: ["ProcessSim"],
            path: "Sources/CLI"
        ),
        .testTarget(
            name: "ProcessSimTests",
            dependencies: ["ProcessSim"],
            path: "Tests"
        )
    ]
)
