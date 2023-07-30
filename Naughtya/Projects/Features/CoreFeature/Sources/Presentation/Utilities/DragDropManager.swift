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
    private static let localStore: LocalStore = .shared
    private static let projectUseCase: ProjectUseCase = DefaultProjectUseCase()
    private static let dailyTodoListUseCase: DailyTodoListUseCase = DefaultDailyTodoListUseCase()
    private static let todoUseCase: TodoUseCase = DefaultTodoUseCase()

    @Published public var dragged: DraggedModel?
    @Published private var absoluteRectMap = [DragDropableHash: CGRect]()

    private init() {
    }

    public func registerAbsoluteRect(
        _ hash: DragDropableHash,
        rect: CGRect
    ) {
        DispatchQueue.global(qos: .userInitiated).sync {
            absoluteRectMap[hash] = rect
        }
    }

    public func unregisterAbsoluteRect(_ hash: DragDropableHash) {
        DispatchQueue.global(qos: .userInitiated).sync {
            absoluteRectMap.removeValue(forKey: hash)
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
        dragged = nil
        Task {
            switch item {
            case let project as ProjectEntity:
                try await dropForProject(
                    project,
                    touchLocation: touchLocation
                )
            case let todo as TodoEntity:
                try await dropForTodo(
                    todo,
                    touchLocation: touchLocation
                )
            default:
                break
            }
        }
    }

    private func dropForProject(
        _ project: ProjectEntity,
        touchLocation: CGPoint
    ) async throws {
        guard let target = getTarget(touchLocation: touchLocation) else {
            return
        }
        switch target {
        case let targetProject as ProjectEntity:
            try await Self.projectUseCase.swapProjects(
                project,
                targetProject
            )
        default:
            break
        }
    }

    private func dropForTodo(
        _ todo: TodoEntity,
        touchLocation: CGPoint
    ) async throws {
        guard let target = getTarget(touchLocation: touchLocation) else {
            return
        }
        switch target {
        case _ as ProjectEntity:
            try await Self.todoUseCase.moveToProject(todo: todo)
        case let targetDailyTodoList as DailyTodoListEntity:
            try await Self.todoUseCase.moveToDaily(
                todo: todo,
                dailyTodoList: targetDailyTodoList
            )
        case let targetTodo as TodoEntity:
            try await Self.todoUseCase.swapTodos(
                todo,
                targetTodo
            )
        default:
            break
        }
    }

    private func getTarget(touchLocation: CGPoint) -> DragDropItemable? {
        absoluteRectMap
            .sorted { $0.key.priority < $1.key.priority }
            .first(where: { $1.contains(touchLocation) })?
            .key.item
    }
}
