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

    func create(
        project: ProjectEntity,
        isDaily: Bool
    ) async throws -> TodoEntity {
        defer { Self.projectStore.update() }
        let todo = TodoEntity(
            project: project,
            isDaily: isDaily
        )
        project.todos.append(todo)
        return todo
    }

    func update(_ todo: TodoEntity, title: String) async throws -> TodoEntity {
        defer { Self.projectStore.update() }
        todo.title = title
        return todo
    }

    func addToDaily(_ todo: TodoEntity) {
        defer { Self.projectStore.update() }
        todo.isDaily = true
    }

    func removeFromDaily(_ todo: TodoEntity) {
        defer { Self.projectStore.update() }
        todo.isDaily = false
    }

    func complete(_ todo: TodoEntity) {
        defer { Self.projectStore.update() }
        todo.completedAt = .now
    }

    func undoCompleted(_ todo: TodoEntity) {
        defer { Self.projectStore.update() }
        todo.completedAt = nil
    }
}
