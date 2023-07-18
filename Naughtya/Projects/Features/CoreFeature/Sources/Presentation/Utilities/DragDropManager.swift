//
//  DragDropManager.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public final class DragDropManager: ObservableObject, DragDropDelegate {
    public static let shared = DragDropManager()
    private static let projectStore: ProjectStore = .shared

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
        if let todo = item as? TodoEntity {
            if let targetTodo = todoAbsoluteRectMap
                .first(where: { $1.contains(touchLocation) })?
                .key {
                todo.swap(targetTodo)
                Self.projectStore.update()
            }
        }
        dragged = nil
    }
}
