//
//  SchedulingManager.swift
//  CoreFeature
//
//  Created by byo on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

final class SchedulingManager {
    let timeSchedule: TimeSchedulable
    let tasksBatch: TasksBatchable
    private var timer: Timer?
    private var lastTime: Time?

    init(
        timeSchedule: TimeSchedulable,
        tasksBatch: TasksBatchable
    ) {
        self.timeSchedule = timeSchedule
        self.tasksBatch = tasksBatch
    }

    private func setup() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [unowned self] _ in
            guard let currentTime = Self.currentTime else {
                return
            }
            batchTasksIfTimeScheduled(currentTime)
            lastTime = currentTime
        }
    }

    private func batchTasksIfTimeScheduled(_ currentTime: Time) {
        guard currentTime != lastTime,
              currentTime == timeSchedule.scheduledTime else {
            return
        }
        tasksBatch.batchTasks()
    }

    private static var currentTime: Time? {
        let components = Calendar.current.dateComponents(
            [.hour, .minute],
            from: .now
        )
        guard let hour = components.hour,
              let minute = components.minute else {
            return nil
        }
        return Time(
            hour: hour,
            minute: minute
        )
    }
}
