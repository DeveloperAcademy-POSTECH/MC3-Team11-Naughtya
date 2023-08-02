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
    private static let localStore: LocalStore = .shared
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
    @State private var isDeleting = false
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
                        Color.customGray7
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
        .gesture(dragGesture)
        .onAppear {
            focusTextFieldIfNeeded()
        }
        .onHover {
            isHovered = $0
        }
        .onDisappear {
            dragDropDelegate.unregisterAbsoluteRect(dragDropableHash)
        }
    }

    private var contentView: some View {
        HStack(spacing: 4) {
            dragDropIndicator
            completionButton
            if !isBacklog {
                categoryText
            }
            titleView
            deleteButton
        }
        .padding(.horizontal, 4)
    }

    private var dragDropIndicator: some View {
        MacOSCoreFeatureAsset.todoHover.swiftUIImage
            .opacity(isHovered ? 1 : 0.001)
            .frame(width: 10, height: 20)
            .animation(.easeOut, value: isHovered)
    }

    private var completionButton: some View {
        Button {
            toggleCompleted()
        } label: {
            Image(systemName: todo.isCompleted ? "checkmark.square" : "square")
                .foregroundColor(todo.isCompleted ? .customGray4 : .pointColor)
                .font(.system(size: 20, weight: .semibold))
                .animation(.easeOut(duration: 0.1), value: todo.isCompleted)
        }
        .buttonStyle(.borderless)
    }

    private var categoryText: some View {
        Text("[\(todo.category)]")
            .font(.system(size: 16, weight: .bold))
    }

    private var titleView: some View {
        ZStack {
            titleTextField
            if isStatic {
                titleText
            }
        }
        .font(.system(size: 16))
        .frame(height: 16)
    }

    private var titleTextField: some View {
        TextField(text: $title) {
            if focusedField == .textField {
                Text("프로젝트에 할 일을 적어봐요.")
                    .foregroundColor(.customGray4)
            }
        }
        .textFieldStyle(.plain)
        .focused($focusedField, equals: .textField)
        .opacity(isStatic ? 0 : 1)
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
            Task {
                try await appendMultiLineTodosIfNeeded()
            }
        }
        .onSubmit {
            updateTitle()
            Task {
                try await appendNextTodo()
            }
        }
    }

    private var titleText: some View {
        HStack {
            Text(title)
                .foregroundColor(todo.isCompleted ? .customGray4 : .white)
                .strikethrough(todo.isCompleted)
                .onTapGesture {
                    focusedField = .textField
                }
            Spacer()
        }
    }

    private var deleteButton: some View {
        Button {
            delete()
        } label: {
            Image(systemName: isDeleting ? "xmark.square" : "trash")
                .font(.system(size: 20))
                .foregroundColor(isDeleting ? .red : Color.customGray4)
        }
        .padding(.trailing, 10)
        .buttonStyle(.borderless)
        .opacity(isHovered ? 1 : 0.001)
        .animation(.easeOut, value: isHovered)
        .onChange(of: isHovered) {
            guard !$0 else {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isDeleting = false
            }
        }
    }

    private var dragGesture: some Gesture {
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
    }

    private var isStatic: Bool {
        !title.isEmpty && focusedField == nil
    }

    private var dragDropableHash: DragDropableHash {
        DragDropableHash(
            item: todo.entity,
            priority: 0
        )
    }

    private func registerAbsoluteRect(_ rect: CGRect) {
        absoluteRect = rect
        dragDropDelegate.registerAbsoluteRect(
            dragDropableHash,
            rect: rect
        )
    }

    private func toggleCompleted() {
        guard !title.isEmpty else {
            return
        }
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

    private func focusTextFieldIfNeeded() {
        guard title.isEmpty else {
            return
        }
        focusedField = .textField
    }

    private func updateTitle() {
        Task {
            try await Self.todoUseCase.update(
                todo.entity,
                title: title
            )
        }
    }

    private func appendMultiLineTodosIfNeeded() async throws {
        guard title.contains("\n") else {
            return
        }
        var titles = title
            .split(separator: "\n")
            .map { String($0) }
        title = titles.removeFirst()
        for title in titles.reversed() {
            try await appendNextTodo(title: title)
        }
    }

    private func appendNextTodo(title: String? = nil) async throws {
        try await Self.todoUseCase.createAfterTodo(
            todo.entity,
            title: title
        )
    }

    private func delete() {
        guard isDeleting else {
            isDeleting = true
            return
        }
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
