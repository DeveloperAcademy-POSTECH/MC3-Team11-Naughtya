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

    private enum FocusableField: Hashable {
        case textField
    }

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
    @FocusState private var focusedField: FocusableField?

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
                    contentView
                }
                .frame(height: 42)
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
        .frame(height: 47)
        .opacity(isDummy || isBeingDragged ? 0.5 : 1)
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

    private var contentView: some View {
        HStack {
            dragDropIndicator
            completionButton
            if !isBacklog {
                categoryText
            }
            titleView
            controlButtons
        }
    }

    private var dragDropIndicator: some View {
        Text("🖱️")
            .opacity(isHovered ? 1 : 0.01)
            .animation(.easeOut, value: isHovered)
    }

    private var completionButton: some View {
        Button {
            toggleCompleted()
        } label: {
            Image(systemName: todo.isCompleted ? "checkmark.square" : "square")
                .foregroundColor(todo.isCompleted ? .customGray3 : .pointColor)
                .font(.system(size: 22))
        }
        .buttonStyle(.borderless)
    }

    private var categoryText: some View {
        Text("[\(todo.category)]")
            .font(Font.custom("SF Pro", size: 16).weight(.bold))
    }

    private var titleView: some View {
        ZStack {
            titleTextField
            if focusedField == nil {
                titleText
            }
        }
        .font(Font.custom("SF Pro", size: 16))
    }

    private var titleTextField: some View {
        TextField(text: $title) {
            Text("Todo")
                .foregroundColor(.customGray3)
        }
        .textFieldStyle(.plain)
        .background(Color.clear)
        .padding(.leading, -8)
        .focused($focusedField, equals: .textField)
        .opacity(focusedField == .textField ? 1 : 0)
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

    private var titleText: some View {
        HStack {
            Text(title)
                .foregroundColor(todo.isCompleted ? .customGray3 : .white)
                .strikethrough(todo.isCompleted)
                .onTapGesture {
                    focusedField = .textField
                }
            Spacer()
        }
    }

    private var controlButtons: some View {
        HStack {
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
