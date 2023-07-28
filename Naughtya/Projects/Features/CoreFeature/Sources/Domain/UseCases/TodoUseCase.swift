//
//  TodoUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public protocol TodoUseCase {
    @discardableResult
    func create(
        project: ProjectEntity,
        dailyTodoList: DailyTodoListEntity?
    ) async throws -> TodoEntity

    func createAfterTodo(_ todo: TodoEntity) async throws

    func readList(searchedText: String) async throws -> [TodoEntity]

    @discardableResult
    func update(
        _ todo: TodoEntity,
        title: String
    ) async throws -> TodoEntity

    @discardableResult
    func update(
        _ todo: TodoEntity,
        dailyTodoList: DailyTodoListEntity?
    ) async throws -> TodoEntity

    func delete(_ todo: TodoEntity) async throws

    func complete(
        _ todo: TodoEntity,
        date: Date?
    ) async throws

    func undoCompleted(_ todo: TodoEntity) async throws
    func moveToProject(todo: TodoEntity) async throws

    func moveToDaily(
        todo: TodoEntity,
        dailyTodoList: DailyTodoListEntity
    ) async throws

    func swapTodos(
        _ lhs: TodoEntity,
        _ rhs: TodoEntity
    ) async throws
}
