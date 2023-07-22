//
//  DragDropManager.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public final class DragDropManager: ObservableObject, DragDropDelegate {
    public static let shared: DragDropManager = .init()
    private static let projectStore: ProjectStore = .shared
    private static let dailyTodoListStore: DailyTodoListStore = .shared
    private static let todoUseCase: TodoUseCase = MockTodoUseCase()

    @Published public var dragged: DraggedModel?
    @Published public var todoAbsoluteRectMap = [TodoEntity: CGRect]()

    private init() {
    }

    public func registerAbsoluteRect(
        _ item: DragDropItemable,
        rect: CGRect
    ) {
        if let todo = item as? TodoEntity {
            todoAbsoluteRectMap[todo] = rect
        }
    }

    public func unregisterAbsoluteRect(_ item: DragDropItemable) {
        if let todo = item as? TodoEntity {
            todoAbsoluteRectMap.removeValue(forKey: todo)
        }
    }

    public func startToDrag(
        _ item: DragDropItemable,
        size: CGSize,
        itemLocation: CGPoint
    ) {
        dragged = DraggedModel(
            item: item,
            size: size,
            location: itemLocation
        )
    }

    public func drag(
        _ item: DragDropItemable,
        itemLocation: CGPoint
    ) {
        dragged?.location = itemLocation
    }

    public func drop(
        _ item: DragDropItemable,
        touchLocation: CGPoint
    ) {
        if let todo = item as? TodoEntity,
           let targetTodo = getTargetTodo(touchLocation: touchLocation) {
            Task {
                try await Self.todoUseCase.swapTodos(todo, targetTodo)
            }
        }
        dragged = nil
    }

    private func getTargetTodo(touchLocation: CGPoint) -> TodoEntity? {
        todoAbsoluteRectMap
            .first(where: { $1.contains(touchLocation) })?
            .key
    }
}
