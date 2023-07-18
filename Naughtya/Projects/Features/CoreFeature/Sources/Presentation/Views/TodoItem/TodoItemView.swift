//
//  TodoItemView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct TodoItemView: View {
    private static let projectUseCase: ProjectUseCase = MockProjectUseCase()
    private static let todoUseCase: TodoUseCase = MockTodoUseCase()

    public let todo: TodoModel
    public let isDummy: Bool
    public let dragDropDelegate: DragDropDelegate
    @State private var absoluteRect: CGRect!
    @State private var isBeenDragging = false

    public init(
        todo: TodoModel,
        isDummy: Bool = false,
        dragDropDelegate: DragDropDelegate = DragDropManager.shared
    ) {
        self.todo = todo
        self.isDummy = isDummy
        self.dragDropDelegate = dragDropDelegate
    }

    public var body: some View {
        GeometryReader { geometry in
            let absoluteRect = geometry.frame(in: .global)
            VStack {
                Spacer()
                HStack(alignment: .center) {
                    Button(todo.isCompleted ? "✅" : "◻️") {
                        toggleCompleted(todo.entity)
                    }
                    .buttonStyle(.borderless)
                    Text("\(todo.id.hashValue)")
                    if !todo.isCompleted {
                        Button("🔄") {
                            toggleDaily(todo.entity)
                        }
                        .buttonStyle(.borderless)
                    }
                    Button("🚮") {
                        delete(todo.entity)
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
    }

    private func setupAbsoluteRect(_ rect: CGRect) {
        absoluteRect = rect
        dragDropDelegate.registerAbsoluteRect(
            todo.entity,
            rect: rect
        )
    }

    private func toggleDaily(_ todo: TodoEntity) {
        Task {
            if todo.isDaily {
                try Self.todoUseCase.removeFromDaily(todo)
            } else {
                try Self.todoUseCase.addToDaily(todo)
            }
        }
    }

    private func toggleCompleted(_ todo: TodoEntity) {
        Task {
            if todo.isCompleted {
                try Self.todoUseCase.undoCompleted(todo)
            } else {
                try Self.todoUseCase.complete(todo)
            }
        }
    }

    private func delete(_ todo: TodoEntity) {
        Task {
            try Self.projectUseCase.delete(todo: todo)
        }
    }
}

struct TodoItemView_Previews: PreviewProvider {
    static var previews: some View {
        TodoItemView(todo: .from(entity: TodoEntity.sample))
    }
}
