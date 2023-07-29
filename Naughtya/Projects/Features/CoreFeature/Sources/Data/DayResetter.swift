//
//  DayResetter.swift
//  CoreFeature
//
//  Created by byo on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

final class DayResetter: TimeSchedulable, TasksBatchable {
    private static let dailyTodoListUseCase: DailyTodoListUseCase = DefaultDailyTodoListUseCase()

    var scheduledTime: Time

    init(scheduledTime: Time) {
        self.scheduledTime = scheduledTime
    }

    func batchTasks() {
        Task {
            try await Self.dailyTodoListUseCase.removeUncompletedTodosFromDaily()
        }
    }
}
