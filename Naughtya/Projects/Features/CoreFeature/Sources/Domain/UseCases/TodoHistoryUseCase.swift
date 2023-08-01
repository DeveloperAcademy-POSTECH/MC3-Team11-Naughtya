//
//  TodoHistoryUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/08/01.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

protocol TodoHistoryUseCase {
    @discardableResult
    func create(
        dailyTodoList: DailyTodoListEntity?,
        isCompleted: Bool,
        createdAt: Date?
    ) async throws -> TodoHistoryEntity
}
