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

            if todos.isEmpty {
                HStack(alignment: .center, spacing: 4) {
                    Text("데일리 투두에 오늘 할일을 드래그 해주세요")
                      .font(Font.custom("Apple SD Gothic Neo", size: 16))
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                      .frame(width: 277, height: 16, alignment: .center)
                      .padding(.vertical, 8)
                      .cornerRadius(5)
                      .overlay(
                        RoundedRectangle(cornerRadius: 5)
                          .inset(by: 0.5)
                          .stroke(Color(red: 0.31, green: 0.31, blue: 0.31), lineWidth: 1)
                          .frame(width: 600, height: 50)
                      )
                }
                .padding()
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            } else {
                ForEach(todos) { todo in
                    TodoItemView(
                        todo: todo,
                        isBacklog: section is ProjectEntity,
                        isBlockedToEdit: searchManager.isSearching
                    )
                }

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
