// swift-tools-version:6.2
//
// This source file is part of the My Heart Counts open source project
// 
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import class Foundation.ProcessInfo
import PackageDescription


let package = Package(
    name: "MHCStudyDefinition",
    platforms: [
        .iOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
        .macOS(.v15),
        .macCatalyst(.v18)
    ],
    products: [
        .library(name: "MHCStudyDefinition", targets: ["MHCStudyDefinition"]),
        .executable(name: "MHCStudyDefinitionExporter", targets: ["MHCStudyDefinitionExporter"])
    ],
    dependencies: [
        .package(url: "https://github.com/StanfordSpezi/SpeziStudy.git", revision: "2dec2daf02da95afe00c2e79abca0ed8d0b15e37"),
        .package(url: "https://github.com/StanfordSpezi/SpeziFoundation.git", from: "2.4.0")
    ],
    targets: [
        .target(
            name: "MHCStudyDefinition",
            dependencies: [
                .product(name: "SpeziStudyDefinition", package: "SpeziStudy")
            ]
        ),
        .executableTarget(
            name: "MHCStudyDefinitionExporter",
            dependencies: [
                "MHCStudyDefinition",
                .product(name: "SpeziStudyDefinition", package: "SpeziStudy"),
                .product(name: "SpeziStudy", package: "SpeziStudy"),
                .product(name: "SpeziLocalization", package: "SpeziFoundation")
            ],
            resources: [
                .copy("Resources/consent"),
                .copy("Resources/article"),
                .copy("Resources/questionnaire"),
                .copy("Resources/hhdExplainer")
            ],
            swiftSettings: [.defaultIsolation(MainActor.self)]
        ),
        .testTarget(
            name: "MHCStudyDefinitionExporterTests",
            dependencies: ["MHCStudyDefinition"]
        )
    ]
)
