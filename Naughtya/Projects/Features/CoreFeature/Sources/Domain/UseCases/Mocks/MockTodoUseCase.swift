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

    func create(
        project: ProjectEntity,
        dailyTodoList: DailyTodoListEntity?
    ) throws -> TodoEntity {
        defer { updateStores() }
        let todo = TodoEntity(
            project: project,
            dailyTodoList: dailyTodoList
        )
        project.todos.append(todo)
        dailyTodoList?.todos.append(todo)
        return todo
    }

    func readList(searchedText: String) throws -> [TodoEntity] {
        Self.projectStore.projects
            .flatMap { $0.todos }
            .filter { $0.title.contains(searchedText) && !$0.isPlaceholder }
    }

    func update(
        _ todo: TodoEntity,
        title: String
    ) throws -> TodoEntity {
        defer { updateStores() }
        todo.title = title
        return todo
    }

    func delete(_ todo: TodoEntity) throws {
        defer { updateStores() }
        todo.project.todos.removeAll { $0 === todo }
        todo.dailyTodoList?.todos.removeAll { $0 === todo }
    }

    func complete(_ todo: TodoEntity) throws {
        defer { updateStores() }
        todo.completedAt = .now
    }

    func undoCompleted(_ todo: TodoEntity) throws {
        defer { updateStores() }
        todo.completedAt = nil
    }

    func swap(_ lhs: TodoEntity, _ rhs: TodoEntity) throws {
        defer { updateStores() }
        switch (lhs.isDaily, rhs.isDaily) {
        case (false, false):
            swapInProject(lhs, rhs)
        case (false, true):
            moveToDaily(lhs, rhs)
        case (true, false):
            moveToProject(lhs, rhs)
        case (true, true):
            swapInDaily(lhs, rhs)
        }
    }

    private func swapInProject(_ lhs: TodoEntity, _ rhs: TodoEntity) {
        if rhs.isPlaceholder {
            lhs.project.todos.removeAll(where: { $0 === lhs })
            lhs.project.todos.append(lhs)
        } else if lhs.project === rhs.project,
                  let indexInProject = rhs.project.todos.firstIndex(of: rhs) {
            lhs.project.todos.removeAll(where: { $0 === lhs })
            lhs.project.todos.insert(lhs, at: indexInProject)
        }
    }

    private func moveToDaily(_ lhs: TodoEntity, _ rhs: TodoEntity) {
        lhs.dailyTodoList = rhs.dailyTodoList
        swapInDaily(lhs, rhs)
    }

    private func moveToProject(_ lhs: TodoEntity, _ rhs: TodoEntity) {
        guard lhs.project === rhs.project else {
            return
        }
        lhs.dailyTodoList?.todos.removeAll(where: { $0 === lhs })
        lhs.dailyTodoList = nil
        swapInProject(lhs, rhs)
    }

    private func swapInDaily(_ lhs: TodoEntity, _ rhs: TodoEntity) {
        if rhs.isPlaceholder {
            lhs.dailyTodoList?.todos.removeAll(where: { $0 === lhs })
            lhs.dailyTodoList?.todos.append(lhs)
        } else if let indexInDaily = rhs.dailyTodoList?.todos.firstIndex(of: rhs) {
            lhs.dailyTodoList?.todos.removeAll(where: { $0 === lhs })
            lhs.dailyTodoList?.todos.insert(lhs, at: indexInDaily)
        }
    }

    private func updateStores() {
        Self.projectStore.update()
        Self.dailyTodoListStore.update()
    }
}
