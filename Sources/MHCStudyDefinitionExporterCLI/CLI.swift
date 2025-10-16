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
@_spi(APISupport)
import SpeziStudyDefinition


@main
struct MHCStudyDefinitionExporterCLI: ParsableCommand {
    private struct Failure: Error {}
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            subcommands: [Export.self, Validate.self]
        )
    }
}


struct Export: ParsableCommand {
    private struct Failure: Error {}
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "export",
            abstract: "Exports the My Heart Counts study definition into an archive or bundle."
        )
    }
    
    @Option(help: "The desired output format")
    var format: Format = .archive
    
    @Argument(help: "Directory into which the output file should be stored.")
    var outputDir: String = "."
    
    init() {}
    
    init(format: Format, outputDir: URL) {
        self.format = format
        self.outputDir = outputDir.absoluteURL.path(percentEncoded: false)
    }
    
    func run() throws {
        do {
            let outputDir = URL(filePath: outputDir, relativeTo: .currentDirectory())
            try export(to: outputDir, as: format)
        } catch StudyBundle.CreateBundleError.failedValidation(let issues) {
            print("Failed Validation: found \(issues.count) issue\(issues.count == 1 ? "" : "s")")
            for (idx, issue) in issues.enumerated() {
                print("\n[\(String(format: "%02li", idx + 1))] \(issue)")
            }
            throw Failure()
        } catch {
            throw error
        }
    }
}


struct Validate: ParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(abstract: "Validate the study definition without actually exporting it to disk.")
    }
    
    func run() throws {
        let fileManager = FileManager.default
        let dir = URL.temporaryDirectory.appending(component: UUID().uuidString, directoryHint: .isDirectory)
        try fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
        defer {
            try? fileManager.removeItem(at: dir)
        }
        try Export(format: .archive, outputDir: dir).run()
    }
}


extension Format: ExpressibleByArgument {
    nonisolated public init?(argument: String) {
        self.init(rawValue: argument)
    }
}
