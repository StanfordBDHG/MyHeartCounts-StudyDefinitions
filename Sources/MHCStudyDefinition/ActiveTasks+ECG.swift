//
// This source file is part of the My Heart Counts open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziStudyDefinition


extension StudyDefinition.CustomActiveTaskComponent.ActiveTask {
    /// The My Heart Count app's ECG active task.
    public static let ecg = Self(identifier: "edu.stanford.MyHeartCounts.activeTask.ecg", title: "ECG", subtitle: nil)
}
