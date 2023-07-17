//
//  MockTodoUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

struct MockTodoUseCase: TodoUseCase {
    func create(project: Project) async throws -> Todo {
        Todo(project: project)
    }

    func update(_ todo: Todo, title: String) async throws -> Todo {
        todo.title = title
        return todo
    }

    func complete(_ todo: Todo) {
        todo.completedAt = .now
    }

    func undoCompleted(_ todo: Todo) {
        todo.completedAt = nil
    }
}
