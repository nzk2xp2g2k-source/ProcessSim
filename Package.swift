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
        ),
        .executable(
            name: "ProcessSimApp",
            targets: ["ProcessSimApp"]
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
        .executableTarget(
            name: "ProcessSimApp",
            dependencies: ["ProcessSim"],
            path: "Sources/ProcessSimApp"
        ),
        .testTarget(
            name: "ProcessSimTests",
            dependencies: ["ProcessSim"],
            path: "Tests"
        )
    ]
)
