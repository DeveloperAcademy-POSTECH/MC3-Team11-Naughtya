//
//  MockTodoUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

struct MockTodoUseCase: TodoUseCase {
    func create(project: ProjectEntity) async throws -> TodoEntity {
        let todo = TodoEntity(project: project)
        project.todos.append(todo)
        return todo
    }

    func update(_ todo: TodoEntity, title: String) async throws -> TodoEntity {
        todo.title = title
        return todo
    }

    func complete(_ todo: TodoEntity) {
        todo.completedAt = .now
    }

    func undoCompleted(_ todo: TodoEntity) {
        todo.completedAt = nil
    }
}
