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

    private let todos: [Todo]

    public init(todos: [Todo]) {
        self.todos = todos
    }

    public var body: some View {
        VStack {
            ForEach(todos) { todo in
                buildTodoItem(todo)
            }
        }
    }

    private func toggleCompleted(_ todo: Todo) {
        if todo.isCompleted {
            Self.todoUseCase.undoCompleted(todo)
        } else {
            Self.todoUseCase.complete(todo)
        }
    }

    private func buildTodoItem(_ todo: Todo) -> some View {
        HStack {
            Button(todo.isCompleted ? "✅" : "◻️") {
                toggleCompleted(todo)
            }
            Text(todo.id.uuidString)
            Spacer()
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(todos: [])
    }
}
