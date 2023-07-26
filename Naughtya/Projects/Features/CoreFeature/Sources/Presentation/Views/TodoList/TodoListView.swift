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
    public let dragDropDelegate: DragDropDelegate
    @ObservedObject private var searchManager = SearchManager.shared
    @State private var absoluteRect: CGRect!

    public init(
        section: DragDropItemable? = nil,
        todos: [TodoModel] = [],
        dragDropDelegate: DragDropDelegate = DragDropManager.shared
    ) {
        self.section = section
        self.todos = todos
        self.dragDropDelegate = dragDropDelegate
    }

    public var body: some View {
        VStack(spacing: 0) {
                ForEach(todos) { todo in
                    TodoItemView(
                        todo: todo,
                        isBacklog: section is ProjectEntity,
                        isBlockedToEdit: searchManager.isSearching
                    )
                }
            if section != nil {
                GeometryReader { geometry in
                    let absoluteRect = geometry.frame(in: .global)
                    Color.customGray1
                        .onAppear {
                            registerAbsoluteRect(absoluteRect)
                        }
                        .onChange(of: absoluteRect) {
                            registerAbsoluteRect($0)
                        }
                }
                .frame(height: 200)
            }
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
