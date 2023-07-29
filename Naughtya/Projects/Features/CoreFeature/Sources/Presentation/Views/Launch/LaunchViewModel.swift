//
//  LaunchViewModel.swift
//  CoreFeature
//
//  Created by byo on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public final class LaunchViewModel: ObservableObject {
    private static let schedulingManager: SchedulingManager = .shared

    @Published public private(set) var isLoaded: Bool = false

    public init() {
        setup()
    }

    private func setup() {
        scheduleToResetDay()
        isLoaded = true
    }

    private func scheduleToResetDay() {
        let timeToReset = Time(
            hour: 0,
            minute: 0
        )
        let dayResetter = DayResetter(scheduledTime: timeToReset)
        dayResetter.batchTasks()
        Self.schedulingManager.register(
            timeSchedule: dayResetter,
            tasksBatch: dayResetter
        )
    }
}
