//
// This source file is part of the My Heart Counts open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziStudyDefinition


func tryUnwrap<T>(_ value: T?, _ message: @autoclosure () -> String) throws -> T {
    if let value {
        return value
    } else {
        throw StudyExporterError(message: message())
    }
}

extension StudyBundle.FileReference.Category {
    static let hhdExplainer = Self(rawValue: "hhdExplainer")
}


extension Locale.Language {
    static let english = Locale.Language(identifier: "en")
    static let spanish = Locale.Language(identifier: "es")
}
