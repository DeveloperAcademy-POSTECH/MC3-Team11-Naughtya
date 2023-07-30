//
//  SchedulingStore.swift
//  CoreFeature
//
//  Created by byo on 2023/07/30.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

final class SchedulingStore: ObservableObject {
    static let shared: SchedulingStore = .init()

    var managers: [SchedulingManager] = []

    private init() {
        setup()
    }

    private func setup() {
        let scheduledTime = Time(
            hour: 0,
            minute: 0
        )
        let dayResetter = DayResetter(scheduledTime: scheduledTime)
        let projectResultsBatcher = ProjectResultsGenerator(scheduledTime: scheduledTime)
        managers = [
            SchedulingManager(
                timeSchedule: dayResetter,
                tasksBatch: dayResetter
            ),
            SchedulingManager(
                timeSchedule: projectResultsBatcher,
                tasksBatch: projectResultsBatcher
            )
        ]
    }
}
