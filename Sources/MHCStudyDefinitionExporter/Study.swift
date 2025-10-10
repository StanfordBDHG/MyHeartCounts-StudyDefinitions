//
// This source file is part of the My Heart Counts open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable closure_body_length

import Foundation
import MHCStudyDefinition
import SpeziHealthKit
import enum SpeziHealthKitBulkExport.ExportSessionStartDate
import SpeziScheduler
import SpeziStudyDefinition


extension StudyBundle.FileReference {
    static let welcomeArticle = Self(category: .informationalArticle, filename: "Welcome", fileExtension: "md")
    
    static let activityFitnessSurvey = Self(category: .questionnaire, filename: "ActivityFitness", fileExtension: "json")
    static let dietScoreSurvey = Self(category: .questionnaire, filename: "Diet", fileExtension: "json")
    static let dieseasQoLSurvey = Self(category: .questionnaire, filename: "DiseaseQOL", fileExtension: "json")
    static let exerciseAdequacySurvey = Self(category: .questionnaire, filename: "ExerciseAdequacy", fileExtension: "json")
    static let exerciseMindsetSurvey = Self(category: .questionnaire, filename: "ExerciseProcessMindset", fileExtension: "json")
    static let gad7 = Self(category: .questionnaire, filename: "GAD7", fileExtension: "json")
    static let heartRiskSurvey = Self(category: .questionnaire, filename: "HeartRisk", fileExtension: "json")
    static let infoSurvey = Self(category: .questionnaire, filename: "Info", fileExtension: "json")
    static let nicotineScoreSurvey = Self(category: .questionnaire, filename: "NicotineExposure", fileExtension: "json")
    static let parQPlusSurvey = Self(category: .questionnaire, filename: "ParQ", fileExtension: "json")
    static let susSurvey = Self(category: .questionnaire, filename: "SUS", fileExtension: "json")
    static let who5Survey = Self(category: .questionnaire, filename: "WHO5", fileExtension: "json")
    static let chronotypeSurvey = Self(category: .questionnaire, filename: "Chronotype", fileExtension: "json")
}


let mhcStudyDefinition = StudyDefinition(
    studyRevision: 20,
    metadata: .init(
        id: .mhcStudy,
        title: "My Heart Counts",
        shortTitle: "MHC",
        icon: .systemSymbol("cube.transparent"),
        explanationText: "",
        shortExplanationText: "Improve your cardiovascular health",
        studyDependency: nil,
        participationCriterion: .ageAtLeast(18) && (.isFromRegion(.unitedStates) || .isFromRegion(.unitedKingdom)),
        enrollmentConditions: .none,
        consentFileRef: .init(category: .consent, filename: "Consent", fileExtension: "md")
    ),
    components: [
        .healthDataCollection(.init(
            id: .mhcStudyComponentHealthDataCollection,
            sampleTypes: .init(
                quantity: [
                    .activeEnergyBurned,
                    .basalEnergyBurned,
                    .flightsClimbed,
                    .appleExerciseTime,
                    .appleMoveTime,
                    .appleStandTime,
                    .stepCount,
                    .distanceWalkingRunning,
                    .distanceCycling,
                    .distanceWheelchair,
                    .distanceSwimming,
                    .appleWalkingSteadiness,
                    .sixMinuteWalkTestDistance,
                    .vo2Max,
                    .walkingSpeed,
                    .walkingStepLength,
                    .walkingAsymmetryPercentage,
                    .walkingDoubleSupportPercentage,
                    .stairAscentSpeed,
                    .stairDescentSpeed,
                    .walkingSpeed,
                    .stairAscentSpeed,
                    .stairDescentSpeed,
                    
                    .heartRate,
                    .restingHeartRate,
                    .heartRateVariabilitySDNN,
                    .heartRateRecoveryOneMinute,
                    .atrialFibrillationBurden,
                    .walkingHeartRateAverage,
                    .bloodOxygen,
                    .bodyTemperature,
                    .respiratoryRate,
                    .basalBodyTemperature,
                    .bloodGlucose,
                    .bloodAlcoholContent,
                    .dietaryCholesterol,
                    .dietaryVitaminD,
                    .inhalerUsage,
                    .sixMinuteWalkTestDistance,
                    
                    .height,
                    .bodyMass,
                    .bodyMassIndex,
                    .leanBodyMass,
                    .bodyFatPercentage,
                    .waistCircumference
                ],
                correlation: [
                    .bloodPressure
                ],
                category: [
                    .sleepAnalysis,
                    .appleStandHour,
                    .appleWalkingSteadinessEvent,
                    .lowHeartRateEvent,
                    .highHeartRateEvent,
                    .irregularHeartRhythmEvent,
                    .mindfulSession
                ],
                other: [
                    SampleType.workout,
                    SampleType.electrocardiogram
                ] as [any AnySampleType]
            ),
            historicalDataCollection: .enabled(.last(DateComponents(year: 10)))
        )),
        
        .informational(.init(id: .welcomeArticleComponent, fileRef: .welcomeArticle)),
        
        .questionnaire(.init(id: .dietScoreSurveyComponent, fileRef: .dietScoreSurvey)),
        .questionnaire(.init(id: .nicotineExposureSurveyComponent, fileRef: .nicotineScoreSurvey)),
        .questionnaire(.init(id: .exerciseAdequacySurveyComponent, fileRef: .exerciseAdequacySurvey)),
        .questionnaire(.init(id: .exerciseMindsetSurveyComponent, fileRef: .exerciseMindsetSurvey)),
        .questionnaire(.init(id: .gad7Component, fileRef: .gad7)),
        .questionnaire(.init(id: .infoSurveyComponent, fileRef: .infoSurvey)),
        .questionnaire(.init(id: .susSurveyComponent, fileRef: .susSurvey)),
        .questionnaire(.init(id: .who5SurveyComponent, fileRef: .who5Survey)),
        .questionnaire(.init(id: .heartRiskSurveyComponent, fileRef: .heartRiskSurvey)),
        .questionnaire(.init(id: .parQPlusSurveyComponent, fileRef: .parQPlusSurvey)),
        .customActiveTask(.init(id: .ecgComponent, activeTask: .ecg)),
        .questionnaire(.init(id: .chronotypeSurveyComponent, fileRef: .chronotypeSurvey)),
        
        .timedWalkingTest(.init(
            id: .sixMinWalkTestComponent,
            test: .init(duration: .minutes(6), kind: .walking)
        )),
        .timedWalkingTest(.init(
            id: .twelveMinRunTestComponent,
            test: .init(duration: .minutes(12), kind: .running)
        ))
    ],
    componentSchedules: Array {
        // DAY 1
        StudyDefinition.ComponentSchedule(
            id: .welcomeArticleSchedule,
            componentId: .welcomeArticleComponent,
            scheduleDefinition: .once(.event(.activation, time: .init(hour: 0))), // setting this to midnight to make sure it's first
            completionPolicy: .anytime,
            notifications: .disabled
        )
        StudyDefinition.ComponentSchedule(
            id: .parQPlusSurveySchedule,
            componentId: .parQPlusSurveyComponent,
            scheduleDefinition: .once(.event(.activation)),
            completionPolicy: .anytime,
            notifications: .disabled
        )
        StudyDefinition.ComponentSchedule(
            id: .heartRiskSurveySchedule,
            componentId: .heartRiskSurveyComponent,
            scheduleDefinition: .once(.event(.activation)),
            completionPolicy: .anytime,
            notifications: .disabled
        )
        StudyDefinition.ComponentSchedule(
            id: .dietScoreSurveySchedule,
            componentId: .dietScoreSurveyComponent,
            scheduleDefinition: .repeated(.monthly(interval: 3, day: nil, hour: 6, minute: 0)),
            completionPolicy: .anytime,
            notifications: .enabled(thread: .task, time: .init(hour: 9))
        )
        
        // DAY 2
        
        StudyDefinition.ComponentSchedule(
            id: .activityFitnessSurveySchedule,
            componentId: .activityFitnessSurveyComponent,
            scheduleDefinition: .repeated(.monthly(interval: 6, day: nil, hour: 9, minute: 0), offset: .init(day: 1)),
            completionPolicy: .afterStart,
            notifications: .enabled(thread: .task)
        )
        StudyDefinition.ComponentSchedule(
            id: .chronotypeSurveySchedule,
            componentId: .chronotypeSurveyComponent,
            scheduleDefinition: .once(.event(.activation, offsetInDays: 1, time: nil)),
            completionPolicy: .anytime,
            notifications: .enabled(thread: .task)
        )
        StudyDefinition.ComponentSchedule(
            id: .ecgScheduleInitial,
            componentId: .ecgComponent,
            scheduleDefinition: .once(.event(.activation, offsetInDays: 1, time: .noon)),
            completionPolicy: .anytime,
            notifications: .enabled(thread: .task)
        )
        StudyDefinition.ComponentSchedule(
            id: .ecgScheduleRepeat,
            componentId: .ecgComponent,
            scheduleDefinition: .once(.event(.completedTask(componentId: .ecgComponent), offsetInDays: 5, time: .noon)),
            completionPolicy: .anytime,
            notifications: .enabled(thread: .task)
        )
        
        // DAY 3
        StudyDefinition.ComponentSchedule(
            id: .who5SurveySchedule,
            componentId: .who5SurveyComponent,
            scheduleDefinition: .repeated(.monthly(interval: 3, day: nil, hour: 6, minute: 0), offset: .init(day: 2)),
            completionPolicy: .anytime,
            notifications: .enabled(thread: .task, time: .init(hour: 9))
        )
        StudyDefinition.ComponentSchedule(
            id: .gad7Schedule,
            componentId: .gad7Component,
            scheduleDefinition: .repeated(.monthly(interval: 6, day: nil, hour: 6, minute: 0), offset: .init(day: 2)),
            completionPolicy: .anytime,
            notifications: .enabled(thread: .task, time: .init(hour: 9))
        )
        StudyDefinition.ComponentSchedule(
            id: .diseaseQoLSurveySchedule,
            componentId: .diseaseQoLSurveyComponent,
            scheduleDefinition: .repeated(.monthly(interval: 1, day: nil, hour: 6, minute: 0), offset: .init(day: 2)),
            completionPolicy: .afterStart,
            notifications: .enabled(thread: .task, time: .init(hour: 9))
        )
        
        // DAY 4
        StudyDefinition.ComponentSchedule(
            id: .exerciseAdequacySurveySchedule,
            componentId: .exerciseAdequacySurveyComponent,
            scheduleDefinition: .once(.event(.activation, offsetInDays: 3, time: .init(hour: 6))),
            completionPolicy: .anytime,
            notifications: .enabled(thread: .task, time: .init(hour: 9))
        )
        StudyDefinition.ComponentSchedule(
            id: .exerciseMindsetSurveySchedule,
            componentId: .exerciseMindsetSurveyComponent,
            scheduleDefinition: .once(.event(.activation, offsetInDays: 3, time: .init(hour: 6))),
            completionPolicy: .anytime,
            notifications: .enabled(thread: .task, time: .init(hour: 9))
        )
        StudyDefinition.ComponentSchedule(
            id: .susSurveySchedule,
            componentId: .susSurveyComponent,
            scheduleDefinition: .once(.event(.activation, offsetInDays: 3, time: .init(hour: 6))),
            completionPolicy: .anytime,
            notifications: .enabled(thread: .task, time: .init(hour: 9))
        )
        
        // DAY 5
        StudyDefinition.ComponentSchedule(
            id: .sixMinWalkTestSchedule,
            componentId: .sixMinWalkTestComponent,
            scheduleDefinition: .once(.event(.activation, offsetInDays: 4, time: .init(hour: 6))),
            completionPolicy: .anytime,
            notifications: .enabled(thread: .task, time: .init(hour: 9))
        )
        
        StudyDefinition.ComponentSchedule(
            id: .sixMinWalkTestSchedule,
            componentId: .sixMinWalkTestComponent,
            // Q: could this (with a 4-day offset) subsume the schedule directly above?)
            scheduleDefinition: .repeated(.monthly(interval: 1, day: nil, hour: 6, minute: 0)),
            completionPolicy: .anytime,
            notifications: .enabled(thread: .task, time: .init(hour: 9))
        )
    }
)
