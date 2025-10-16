//
// This source file is part of the My Heart Counts open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ArgumentParser
import Foundation
import MHCStudyDefinitionExporter
@_spi(APISupport) import SpeziStudyDefinition


@main
struct Exporter: ParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "export",
            abstract: "Exports the My Heart Counts study definition into an archive or bundle."
        )
    }
    
    @Option(help: "The desired output format")
    var format: Format = .archive
    
    @Argument(help: "Folder into which the output file should be stored.")
    var outputDir: String = "."
    
    func run() throws {
        do {
            let outputDir = URL(filePath: outputDir, relativeTo: .currentDirectory())
            try export(to: outputDir, as: format)
        } catch StudyBundle.CreateBundleError.failedValidation(let issues) {
            print("Failed Validation: found \(issues.count) issue\(issues.count == 1 ? "" : "s")")
            for (idx, issue) in issues.enumerated() {
                print("\n[\(String(format: "%02li", idx + 1))] \(issue)")
            }
            Foundation.exit(EXIT_FAILURE)
        } catch {
            print("Export failed: \(error)")
            Foundation.exit(EXIT_FAILURE)
        }
    }
}


extension Format: ExpressibleByArgument {
    nonisolated public init?(argument: String) {
        self.init(rawValue: argument)
    }
}
