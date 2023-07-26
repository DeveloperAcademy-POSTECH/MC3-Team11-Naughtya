//
//  DefaultTodoUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

struct DefaultTodoUseCase: TodoUseCase {
    private static let projectStore: ProjectStore = .shared
    private static let dailyTodoListUseCase: DailyTodoListUseCase = DefaultDailyTodoListUseCase()
    private static let cloudKitManager: CloudKitManager = .shared

    func create(
        project: ProjectEntity,
        dailyTodoList: DailyTodoListEntity?
    ) async throws -> TodoEntity {
        let todo = TodoEntity(
            project: project,
            dailyTodoList: dailyTodoList
        )
        Task {
            let record = try? await Self.cloudKitManager.create(todo.record)
            todo.recordId = record?.id
        }
        project.todos.value.append(todo)
        dailyTodoList?.todos.value.append(todo)
        return todo
    }

    func readList(searchedText: String) async throws -> [TodoEntity] {
        guard !searchedText.isEmpty else {
            return []
        }
        return Self.projectStore.projects
            .flatMap { $0.todos.value }
            .filter { $0.title.value.contains(searchedText) }
    }

    func update(
        _ todo: TodoEntity,
        title: String
    ) async throws -> TodoEntity {
        todo.title.value = title
        return todo
    }

    func update(
        _ todo: TodoEntity,
        dailyTodoList: DailyTodoListEntity?
    ) async throws -> TodoEntity {
        todo.dailyTodoList.value = dailyTodoList
        return todo
    }

    func delete(_ todo: TodoEntity) async throws {
        todo.project.value.deletedTodos.value.append(todo)
        todo.project.value.todos.value.removeAll(where: { $0 === todo })
        todo.dailyTodoList.value?.todos.value.removeAll(where: { $0 === todo })
        try? await Self.cloudKitManager.delete(todo.recordId)
    }

    func complete(
        _ todo: TodoEntity,
        date: Date?
    ) async throws {
        todo.completedAt.value = date
    }

    func undoCompleted(_ todo: TodoEntity) async throws {
        todo.completedAt.value = nil
    }

    func moveToProject(todo: TodoEntity) async throws {
        try await Self.dailyTodoListUseCase.removeTodoFromDaily(todo)
        todo.project.value.todos.value.remove(todo)
        todo.project.value.todos.value.append(todo)
    }

    func moveToDaily(
        todo: TodoEntity,
        dailyTodoList: DailyTodoListEntity
    ) async throws {
        try await Self.dailyTodoListUseCase.addTodoToDaily(
            todo: todo,
            dailyTodoList: dailyTodoList
        )
        dailyTodoList.todos.value.remove(todo)
        dailyTodoList.todos.value.append(todo)
    }

    func swapTodos(_ lhs: TodoEntity, _ rhs: TodoEntity) async throws {
        switch (lhs.isDaily, rhs.isDaily) {
        case (false, false):
            swapInProject(lhs, rhs)
        case (false, true):
            try await moveToDaily(lhs, rhs)
        case (true, false):
            try await moveToProject(lhs, rhs)
        case (true, true):
            swapInDaily(lhs, rhs)
        }
    }

    private func moveToProject(_ lhs: TodoEntity, _ rhs: TodoEntity) async throws {
        guard lhs.project.value === rhs.project.value else {
            return
        }
        try await Self.dailyTodoListUseCase.removeTodoFromDaily(lhs)
        swapInProject(lhs, rhs)
    }

    private func moveToDaily(_ lhs: TodoEntity, _ rhs: TodoEntity) async throws {
        try await Self.dailyTodoListUseCase.addTodoToDaily(
            todo: lhs,
            dailyTodoList: rhs.dailyTodoList.value
        )
        swapInDaily(lhs, rhs)
    }

    private func swapInProject(_ lhs: TodoEntity, _ rhs: TodoEntity) {
        guard lhs.project.value === rhs.project.value,
              let indexInProject = rhs.project.value.todos.value.firstIndex(of: rhs) else {
            return
        }
        lhs.project.value.todos.value.remove(lhs)
        lhs.project.value.todos.value.insert(lhs, at: indexInProject)
    }

    private func swapInDaily(_ lhs: TodoEntity, _ rhs: TodoEntity) {
        guard let indexInDaily = rhs.dailyTodoList.value?.todos.value.firstIndex(of: rhs) else {
            return
        }
        lhs.dailyTodoList.value?.todos.value.remove(lhs)
        lhs.dailyTodoList.value?.todos.value.insert(lhs, at: indexInDaily)
    }
}
