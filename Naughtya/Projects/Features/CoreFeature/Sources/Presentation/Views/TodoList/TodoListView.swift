//
//  TodoListView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct TodoListView: View {
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
        VStack(spacing: 0) {
            ForEach(todos.sorted { $1.isPlaceholder }) { todo in
                TodoItemView(
                    todo: todo,
                    isNested: isNested
                )
            }
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(todos: [])
    }
}
