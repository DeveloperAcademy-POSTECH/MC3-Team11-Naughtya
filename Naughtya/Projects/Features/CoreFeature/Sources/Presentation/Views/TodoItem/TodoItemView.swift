//
//  TodoItemView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct TodoItemView: View {
    private static let dailyTodoListUseCase: DailyTodoListUseCase = MockDailyTodoListUseCase()
    private static let todoUseCase: TodoUseCase = MockTodoUseCase()

    public let todo: TodoModel
    public let isNested: Bool
    public let isDummy: Bool
    public let dragDropDelegate: DragDropDelegate
    @State private var title: String
    @State private var absoluteRect: CGRect!
    @State private var isBeenDragging = false

    public init(
        todo: TodoModel,
        isNested: Bool = false,
        isDummy: Bool = false,
        dragDropDelegate: DragDropDelegate = DragDropManager.shared
    ) {
        self.todo = todo
        self.isNested = isNested
        self.isDummy = isDummy
        self.dragDropDelegate = dragDropDelegate
        self.title = todo.title
    }

    public var body: some View {
        GeometryReader { geometry in
            let absoluteRect = geometry.frame(in: .global)
            VStack {
                Spacer()
                HStack(alignment: .center) {
                    Text("🖱️")
                    Button(todo.isCompleted ? "✅" : "◻️") {
                        toggleCompleted()
                    }
                    .buttonStyle(.borderless)
                    if !isNested {
                        Text("[\(todo.category)]")
                            .font(.headline)
                    }
                    TextField(text: $title) {
                        Text("Todo")
                            .foregroundColor(.gray)
                    }
                    .textFieldStyle(.plain)
                    if !todo.isCompleted {
                        Button("🔄") {
                            toggleDaily()
                        }
                        .buttonStyle(.borderless)
                    }
                    Button("🚮") {
                        delete()
                    }
                    .buttonStyle(.borderless)
                    Spacer()
                }
                Spacer()
            }
            .onAppear {
                setupAbsoluteRect(absoluteRect)
            }
            .onChange(of: absoluteRect) {
                guard !(isBeenDragging || isDummy) else {
                    return
                }
                setupAbsoluteRect($0)
            }
        }
        .frame(height: 40)
        .background(.white)
        .opacity(isBeenDragging ? 0 : 1)
        .gesture(
            DragGesture()
                .onChanged {
                    let itemLocation = absoluteRect.origin + $0.location - $0.startLocation
                    if !isBeenDragging {
                        dragDropDelegate.startToDrag(
                            todo.entity,
                            size: absoluteRect.size,
                            itemLocation: itemLocation
                        )
                    } else {
                        dragDropDelegate.drag(
                            todo.entity,
                            itemLocation: itemLocation
                        )
                    }
                    isBeenDragging = true
                }
                .onEnded {
                    isBeenDragging = false
                    dragDropDelegate.drop(
                        todo.entity,
                        touchLocation: absoluteRect.origin + $0.location
                    )
                }
        )
        .onChange(of: title) { _ in
            updateTitle()
        }
    }

    private func setupAbsoluteRect(_ rect: CGRect) {
        absoluteRect = rect
        dragDropDelegate.registerAbsoluteRect(
            todo.entity,
            rect: rect
        )
    }

    private func updateTitle() {
        Task {
            try Self.todoUseCase.update(
                todo.entity,
                title: title
            )
        }
    }

    private func toggleDaily() {
        Task {
            if todo.entity.isDaily {
                try Self.dailyTodoListUseCase.removeTodoFromDaily(todo.entity)
            } else {
                try Self.dailyTodoListUseCase.addTodoToDaily(todo.entity)
            }
        }
    }

    private func toggleCompleted() {
        Task {
            if todo.entity.isCompleted {
                try Self.todoUseCase.undoCompleted(todo.entity)
            } else {
                try Self.todoUseCase.complete(todo.entity)
            }
        }
    }

    private func delete() {
        Task {
            try Self.todoUseCase.delete(todo.entity)
        }
    }
}

struct TodoItemView_Previews: PreviewProvider {
    static var previews: some View {
        TodoItemView(todo: .from(entity: TodoEntity.sample))
    }
}
