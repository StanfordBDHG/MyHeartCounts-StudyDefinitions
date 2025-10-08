//
// This source file is part of the My Heart Counts open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import MHCStudyDefinitionExporter
import Testing


@Suite
struct MHCStudyDefinitionExporterTests {
    @Test
    func export() throws {
        let fileManager = FileManager.default
        let dstDir = URL.temporaryDirectory.appending(component: UUID().uuidString, directoryHint: .isDirectory)
        try fileManager.createDirectory(at: dstDir, withIntermediateDirectories: true)
        let archiveUrl = try MHCStudyDefinitionExporter.export(to: dstDir)
        #expect(try fileManager.itemExists(at: archiveUrl))
        
        // let's clean up after ourselves
        try? fileManager.removeItem(at: dstDir)
    }
}
