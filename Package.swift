// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MusicThreadAPI",
    platforms: [
        .macOS(.v12), .iOS(.v15),
    ],
    products: [
        .library(name: "MusicThreadAPI", targets: ["MusicThreadAPI"]),
        .library(name: "MusicThreadTokenStore", targets: ["MusicThreadTokenStore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/auth0/JWTDecode.swift", from: "2.5.0"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.1"),
    ],
    targets: [
        .target(name: "MusicThreadAPI", dependencies: [
            .product(name: "JWTDecode", package: "JWTDecode.swift"),
        ]),
        .target(name: "MusicThreadTokenStore", dependencies: [
            .target(name: "MusicThreadAPI"),
            .product(name: "KeychainAccess", package: "KeychainAccess"),
        ]),
    ]
)
