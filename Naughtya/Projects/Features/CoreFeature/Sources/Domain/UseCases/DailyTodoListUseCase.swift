//
//  DailyTodoListUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/19.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public protocol DailyTodoListUseCase {
    @discardableResult
    func create(dateString: String) async throws -> DailyTodoListEntity

    func readByDate(dateString: String) async throws -> DailyTodoListEntity?

    func addTodoToDaily(
        todo: TodoEntity,
        dailyTodoList: DailyTodoListEntity?
    ) async throws

    func removeTodoFromDaily(_ todo: TodoEntity) async throws
}
