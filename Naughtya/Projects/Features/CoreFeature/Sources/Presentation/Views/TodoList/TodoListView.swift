//
//  TodoListView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct TodoListView: View {
    private static let todoUseCase: TodoUseCase = MockTodoUseCase()

    public let todos: [TodoModel]
    public let isNested: Bool

    public init(
        todos: [TodoModel] = [],
        isNested: Bool = false
    ) {
        self.todos = todos
        self.isNested = isNested
    }

    public var body: some View {
        VStack(spacing: 8) {
            ForEach(todos) { todo in
                buildTodoItem(todo)
            }
        }
    }

    private func toggleDaily(_ todo: TodoEntity) {
        if todo.isDaily {
            Self.todoUseCase.removeFromDaily(todo)
        } else {
            Self.todoUseCase.addToDaily(todo)
        }
    }

    private func toggleCompleted(_ todo: TodoEntity) {
        if todo.isCompleted {
            Self.todoUseCase.undoCompleted(todo)
        } else {
            Self.todoUseCase.complete(todo)
        }
    }

    private func buildTodoItem(_ todo: TodoModel) -> some View {
        HStack {
            Button(todo.isCompleted ? "✅" : "◻️") {
                toggleCompleted(todo.entity)
            }
            if !isNested {
                Text("[\(todo.category)]")
                    .font(.headline)
            }
            Text(todo.id.uuidString.prefix(8))
            if !todo.isCompleted {
                Button("🔄") {
                    toggleDaily(todo.entity)
                }
            }
            Spacer()
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(todos: [])
    }
}
