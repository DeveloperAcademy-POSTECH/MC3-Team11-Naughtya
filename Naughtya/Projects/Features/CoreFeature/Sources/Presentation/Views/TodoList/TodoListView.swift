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
                    Color.black.opacity(0.001)
                        .onAppear {
                            registerAbsoluteRect(absoluteRect)
                        }
                        .onChange(of: absoluteRect) {
                            registerAbsoluteRect($0)
                        }
                }
            }
            if section is DailyTodoListEntity,
               todos.isEmpty {
                emptyView
                    .padding(.top, 8)
                    .padding(.bottom, 500)
            } else if section is DailyTodoListEntity,
                      !todos.isEmpty {
                VStack(spacing: 0) {
                    ForEach(todos) { todo in
                        TodoItemView(
                            todo: todo,
                            isBacklog: section is ProjectEntity,
                            isBlockedToEdit: isBlockedToEdit
                        )
                    }
                }
                .padding(.bottom, 500)
            } else {
                VStack(spacing: 0) {
                    ForEach(todos) { todo in
                        TodoItemView(
                            todo: todo,
                            isBacklog: section is ProjectEntity,
                            isBlockedToEdit: isBlockedToEdit
                        )
                    }
                }
            }
        }
        .onDisappear {
            unregisterAbsoluteRect()
        }
    }

    private var emptyView: some View {
         HStack {
             Spacer()
             Text("프로젝트 할 일을 드래그 해주세요.")
                 .multilineTextAlignment(.center)
                 .foregroundColor(Color.customGray3)
                 .font(.appleSDGothicNeo(size: 16))
             Spacer()
         }
         .frame(height: 42)
         .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.customGray7)
         )
    }

    private var dragDropableHash: DragDropableHash? {
        guard let item = section else {
            return nil
        }
        return DragDropableHash(
            item: item,
            priority: 2
        )
    }

    private func registerAbsoluteRect(_ rect: CGRect) {
        guard let hash = dragDropableHash else {
            return
        }
        absoluteRect = rect
        dragDropDelegate.registerAbsoluteRect(
            hash,
            rect: rect
        )
    }

    private func unregisterAbsoluteRect() {
        guard let hash = dragDropableHash else {
            return
        }
        dragDropDelegate.unregisterAbsoluteRect(hash)
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
