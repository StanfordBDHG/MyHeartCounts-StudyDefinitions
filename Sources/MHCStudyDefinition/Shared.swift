//
// This source file is part of the My Heart Counts open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziStudyDefinition


extension StudyBundle.FileReference.Category {
    /// The My Heart Counts app's Heart Health Dasboard explainer file category.
    public static let hhdExplainer = Self(rawValue: "hhdExplainer")
}

extension StudyDefinition.CustomActiveTaskComponent.ActiveTask {
    /// The My Heart Counts app's ECG active task.
    public static let ecg = Self(
        identifier: "edu.stanford.MyHeartCounts.activeTask.ecg",
        title: "ECG",
        subtitle: "Capture ECG on your apple watch"
    )
}
