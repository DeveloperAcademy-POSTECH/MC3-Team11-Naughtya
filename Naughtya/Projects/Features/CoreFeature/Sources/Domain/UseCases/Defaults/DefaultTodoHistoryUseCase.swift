//
//  DefaultTodoHistoryUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/08/01.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

struct DefaultTodoHistoryUseCase: TodoHistoryUseCase {
    private static let cloudKitManager: CloudKitManager = .shared

    func create(
        dailyTodoList: DailyTodoListEntity?,
        isCompleted: Bool,
        createdAt: Date?
    ) async throws -> TodoHistoryEntity {
        let todoHistory = TodoHistoryEntity(
            dailyTodoList: dailyTodoList,
            isCompleted: isCompleted,
            createdAt: createdAt
        )
        Task {
            let record = try? await Self.cloudKitManager.create(todoHistory.record)
            todoHistory.recordId = record?.id
        }
        return todoHistory
    }
}
