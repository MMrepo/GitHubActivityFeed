// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "Routable",
                      platforms: [.iOS(.v12)],
                      products: [.library(name: "Routable",
                                          targets: ["Routable"])],
                      dependencies: [// Dependencies declare other packages that this package depends on.
                      ],
                      targets: [.target(name: "Routable",
                                        dependencies: []),
                                .testTarget(name: "RoutableTests",
                                            dependencies: ["Routable"])])
