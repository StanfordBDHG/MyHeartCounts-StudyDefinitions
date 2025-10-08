//
// This source file is part of the My Heart Counts open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import MHCStudyDefinitionExporter
@_spi(APISupport) import SpeziStudyDefinition


do {
    guard let outputDir = CommandLine.arguments.firstIndex(of: "-o")
        .flatMap({ CommandLine.arguments[safe: $0 + 1] })
        .map({ URL(filePath: $0, relativeTo: .currentDirectory()).absoluteURL }) else {
            print("Missing '-o outputDir' option")
            exit(EXIT_FAILURE)
    }
    try export(to: outputDir)
    exit(EXIT_SUCCESS)
} catch StudyBundle.CreateBundleError.failedValidation(let issues) {
    print("Failed Validation:")
    for (idx, issue) in issues.enumerated() {
        fputs("\n[\(String(format: "%02li", idx + 1))] \(issue)\n", stderr)
    }
    exit(EXIT_FAILURE)
} catch {
    print("Export failed: \(error)")
    exit(EXIT_FAILURE)
}
