// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "Architecture",
                      platforms: [.iOS(.v13)],
                      products: [.library(name: "Architecture",
                                          targets: ["Architecture"])],
                      dependencies: [],
                      targets: [.target(name: "Architecture",
                                        dependencies: []),
                                .testTarget(name: "ArchitectureTests",
                                            dependencies: ["Architecture"])])
