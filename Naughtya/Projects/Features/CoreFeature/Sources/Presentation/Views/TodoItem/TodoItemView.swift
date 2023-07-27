//
//  TodoItemView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI
import Combine

public struct TodoItemView: View {
    private static let dailyTodoListStore: DailyTodoListStore = .shared
    private static let dailyTodoListUseCase: DailyTodoListUseCase = DefaultDailyTodoListUseCase()
    private static let todoUseCase: TodoUseCase = DefaultTodoUseCase()

    public let todo: TodoModel
    public let isBacklog: Bool
    public let isDummy: Bool
    public let isBlockedToEdit: Bool
    public let dragDropDelegate: DragDropDelegate
    private let titlePublisher: PassthroughSubject<String, Never> = .init()
    @State private var title: String
    @State private var absoluteRect: CGRect!
    @State private var isHovered = false
    @State private var isBeingDragged = false

    public init(
        todo: TodoModel,
        isBacklog: Bool = false,
        isDummy: Bool = false,
        isBlockedToEdit: Bool = false,
        dragDropDelegate: DragDropDelegate = DragDropManager.shared
    ) {
        self.todo = todo
        self.isBacklog = isBacklog
        self.isDummy = isDummy
        self.isBlockedToEdit = isBlockedToEdit
        self.dragDropDelegate = dragDropDelegate
        self.title = todo.title
    }

    public var body: some View {
        GeometryReader { geometry in
            let absoluteRect = geometry.frame(in: .global)
            VStack {
                Spacer()
                ZStack {
                    if isHovered {
                        Color.customGray5
                    }
                    HStack(alignment: .center) {
                        Text("🖱️")
                            .opacity(isHovered ? 1 : 0.01)
                            .animation(.easeOut, value: isHovered)
                        Button(action: {
                            toggleCompleted()
                        }, label: {
                            Image(systemName: todo.isCompleted ? "checkmark.square" : "square")
                                .foregroundColor(todo.isCompleted ? Color.customGray3 : Color.pointColor)
                                .font(.system(size: 22))
                        })
                        .buttonStyle(.borderless)
                        if !isBacklog {
                            Text("[\(todo.category)]")
                                .font(
                                    Font.custom("Apple SD Gothic Neo", size: 16)
                                        .weight(.bold)
                                )
                        }
                        ZStack {
                            if todo.isCompleted {
                                Text("\(todo.title)")
                                    .strikethrough()
                                    .font(Font.custom("Apple SD Gothic Neo", size: 16))
                                    .textFieldStyle(.plain)

                                    .foregroundColor(Color.customGray3)
                            } else {
                                TextField(text: $title) {
                                    placeholder
                                }
                                .padding(.leading, -8)
                                .font(Font.custom("Apple SD Gothic Neo", size: 16))
                                .textFieldStyle(.plain)
                                .onChange(of: title) {
                                    titlePublisher.send($0)
                                }
                                .onReceive(
                                    titlePublisher
                                        .debounce(
                                            for: .milliseconds(100),
                                            scheduler: DispatchQueue.global(qos: .userInteractive)
                                        )
                                ) { _ in
                                    updateTitle()
                                }
                                .onSubmit {
                                    updateTitle()
                                }
                            }
                        }
                        Button {
                            toggleDaily()
                        } label: {
                            Text(todo.isCompleted ? "" : "🔄")
                        }
                        .buttonStyle(.borderless)
                        Button {
                            delete()
                        } label: {
                            Text(todo.isCompleted ? "" : "🚮")
                        }
                        .buttonStyle(.borderless)
                        Spacer()
                    }
                }
                Spacer()
            }
            .onAppear {
                registerAbsoluteRect(absoluteRect)
            }
            .onChange(of: absoluteRect) {
                guard !(isBeingDragged || isDummy) else {
                    return
                }
                registerAbsoluteRect($0)
            }
            .onChange(of: isBeingDragged) {
                guard !$0 else {
                    return
                }
                registerAbsoluteRect(absoluteRect)
            }
        }
        .frame(height: 40)
        .opacity(opacity)
        .gesture(
            DragGesture()
                .onChanged {
                    let itemLocation = absoluteRect.origin + $0.location - $0.startLocation
                    if !isBeingDragged {
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
                    isBeingDragged = true
                }
                .onEnded {
                    dragDropDelegate.drop(
                        todo.entity,
                        touchLocation: absoluteRect.origin + $0.location
                    )
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isBeingDragged = false
                    }
                }
        )
        .onHover {
            isHovered = $0
        }
        .onDisappear {
            dragDropDelegate.unregisterAbsoluteRect(todo.entity)
        }
    }

    private var placeholder: some View {
        Text("Todo")
            .foregroundColor(Color.customGray3)
    }

    private var opacity: CGFloat {
        if isDummy || isBeingDragged {
            return 0.5
        } else {
            return 1
        }
    }

    private func registerAbsoluteRect(_ rect: CGRect) {
        absoluteRect = rect
        dragDropDelegate.registerAbsoluteRect(
            todo.entity,
            rect: rect
        )
    }

    private func updateTitle() {
        Task {
            try await Self.todoUseCase.update(
                todo.entity,
                title: title
            )
        }
    }

    private func toggleDaily() {
        Task {
            if todo.entity.isDaily {
                try await Self.dailyTodoListUseCase.removeTodoFromDaily(todo.entity)
            } else {
                try await Self.dailyTodoListUseCase.addTodoToDaily(
                    todo: todo.entity,
                    dailyTodoList: Self.dailyTodoListStore.currentDailyTodoList
                )
            }
        }
    }

    private func toggleCompleted() {
        Task {
            if todo.entity.isCompleted {
                try await Self.todoUseCase.undoCompleted(todo.entity)
            } else {
                try await Self.todoUseCase.complete(
                    todo.entity,
                    date: .now
                )
            }
        }
    }

    private func delete() {
        Task {
            try await Self.todoUseCase.delete(todo.entity)
        }
    }
}

struct TodoItemView_Previews: PreviewProvider {
    static var previews: some View {
        TodoItemView(todo: .from(entity: .sample))
    }
}
