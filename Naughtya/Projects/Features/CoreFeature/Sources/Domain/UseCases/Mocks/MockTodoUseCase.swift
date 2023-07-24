//
//  MockTodoUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

struct MockTodoUseCase: TodoUseCase {
    private static let projectStore: ProjectStore = .shared
    private static let dailyTodoListStore: DailyTodoListStore = .shared
    private static let dailyTodoListUseCase: DailyTodoListUseCase = MockDailyTodoListUseCase()

    func create(
        project: ProjectEntity,
        dailyTodoList: DailyTodoListEntity?
    ) async throws -> TodoEntity {
        defer { updateStores() }
        let todo = TodoEntity(
            project: project,
            dailyTodoList: dailyTodoList
        )
        project.todos.append(todo)
        dailyTodoList?.todos.append(todo)
        return todo
    }

    func readList(searchedText: String) async throws -> [TodoEntity] {
        guard !searchedText.isEmpty else {
            return []
        }
        return Self.projectStore.projects
            .flatMap { $0.todos }
            .filter { $0.title.contains(searchedText) }
    }

    func update(
        _ todo: TodoEntity,
        title: String
    ) async throws -> TodoEntity {
        defer { updateStores() }
        todo.title = title
        return todo
    }

    func update(
        _ todo: TodoEntity,
        dailyTodoList: DailyTodoListEntity?
    ) async throws -> TodoEntity {
        defer { updateStores() }
        todo.dailyTodoList = dailyTodoList
        return todo
    }

    func delete(_ todo: TodoEntity) async throws {
        defer { updateStores() }
        todo.project.todos.removeAll { $0 === todo }
        todo.dailyTodoList?.todos.removeAll { $0 === todo }
    }

    func complete(
        _ todo: TodoEntity,
        date: Date?
    ) async throws {
        defer { updateStores() }
        todo.completedAt = date
    }

    func undoCompleted(_ todo: TodoEntity) async throws {
        defer { updateStores() }
        todo.completedAt = nil
    }

    func moveToProject(todo: TodoEntity) async throws {
        defer { updateStores() }
        try await Self.dailyTodoListUseCase.removeTodoFromDaily(todo)
        todo.project.todos.remove(todo)
        todo.project.todos.append(todo)
    }

    func moveToDaily(
        todo: TodoEntity,
        dailyTodoList: DailyTodoListEntity
    ) async throws {
        defer { updateStores() }
        try await Self.dailyTodoListUseCase.addTodoToDaily(
            todo: todo,
            dailyTodoList: dailyTodoList
        )
        dailyTodoList.todos.remove(todo)
        dailyTodoList.todos.append(todo)
    }

    func swapTodos(_ lhs: TodoEntity, _ rhs: TodoEntity) async throws {
        defer { updateStores() }
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
        guard lhs.project === rhs.project else {
            return
        }
        try await Self.dailyTodoListUseCase.removeTodoFromDaily(lhs)
        swapInProject(lhs, rhs)
    }

    private func moveToDaily(_ lhs: TodoEntity, _ rhs: TodoEntity) async throws {
        try await Self.dailyTodoListUseCase.addTodoToDaily(
            todo: lhs,
            dailyTodoList: rhs.dailyTodoList
        )
        swapInDaily(lhs, rhs)
    }

    private func swapInProject(_ lhs: TodoEntity, _ rhs: TodoEntity) {
        guard lhs.project === rhs.project,
              let indexInProject = rhs.project.todos.firstIndex(of: rhs) else {
            return
        }
        lhs.project.todos.remove(lhs)
        lhs.project.todos.insert(lhs, at: indexInProject)
    }

    private func swapInDaily(_ lhs: TodoEntity, _ rhs: TodoEntity) {
        guard let indexInDaily = rhs.dailyTodoList?.todos.firstIndex(of: rhs) else {
            return
        }
        lhs.project.todos.remove(lhs)
        lhs.dailyTodoList?.todos.insert(lhs, at: indexInDaily)
    }

    private func updateStores() {
        Self.projectStore.update()
        Self.dailyTodoListStore.update()
    }
}
