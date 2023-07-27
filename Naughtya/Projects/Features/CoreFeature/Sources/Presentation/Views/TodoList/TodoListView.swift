//
//  TodoListView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct TodoListView: View {
    public let section: DragDropItemable?
    public let todos: [TodoModel]
    public let isBlockedToEdit: Bool
    public let dragDropDelegate: DragDropDelegate
    @State private var absoluteRect: CGRect!

    public init(
        section: DragDropItemable? = nil,
        todos: [TodoModel] = [],
        isBlockedToEdit: Bool = false,
        dragDropDelegate: DragDropDelegate = DragDropManager.shared
    ) {
        self.section = section
        self.todos = todos
        self.isBlockedToEdit = isBlockedToEdit
        self.dragDropDelegate = dragDropDelegate
    }

    public var body: some View {
        ZStack {
            if section != nil {
                GeometryReader { geometry in
                    let absoluteRect = geometry.frame(in: .global)
                    Color.black.opacity(0.01)
                        .onAppear {
                            registerAbsoluteRect(absoluteRect)
                        }
                        .onChange(of: absoluteRect) {
                            registerAbsoluteRect($0)
                        }
                }
            }
            VStack(spacing: 0) {
                ForEach(todos) { todo in
                    TodoItemView(
                        todo: todo,
                        isBacklog: section is ProjectEntity,
                        isBlockedToEdit: isBlockedToEdit
                    )
                }
            }
            .padding(.bottom, 100)
        }
        .onDisappear {
            unregisterAbsoluteRect()
        }
    }

    private func registerAbsoluteRect(_ rect: CGRect) {
        guard let section = section else {
            return
        }
        absoluteRect = rect
        dragDropDelegate.registerAbsoluteRect(
            section,
            rect: rect
        )
    }

    private func unregisterAbsoluteRect() {
        guard let section = section else {
            return
        }
        dragDropDelegate.unregisterAbsoluteRect(section)
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(
            section: ProjectEntity.sample,
            todos: []
        )
    }
}
