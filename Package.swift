// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JSONDrivenUI",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "JSONDrivenUI",
            targets: ["JSONDrivenUI"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "SwiftUICharts", url: "https://github.com/SumiMakito/ChartView.git", .revision("5670844a754630ea7c95164ea42b4fed2859f832"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "JSONDrivenUI",
            dependencies: [
                .product(name: "SwiftUICharts", package: "SwiftUICharts")
            ])
    ])
