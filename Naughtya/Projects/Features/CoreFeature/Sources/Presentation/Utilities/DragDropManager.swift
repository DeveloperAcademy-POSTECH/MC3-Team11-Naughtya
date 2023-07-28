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
    private static let projectUseCase: ProjectUseCase = DefaultProjectUseCase()
    private static let dailyTodoListUseCase: DailyTodoListUseCase = DefaultDailyTodoListUseCase()
    private static let todoUseCase: TodoUseCase = DefaultTodoUseCase()

    @Published public var dragged: DraggedModel?
    @Published public var projectAbsoluteRectMap = [ProjectEntity: CGRect]()
    @Published public var dailyTodoListAbsoluteRectMap = [DailyTodoListEntity: CGRect]()
    @Published public var todoAbsoluteRectMap = [TodoEntity: CGRect]()

    private init() {
    }

    public func registerAbsoluteRect(
        _ item: DragDropItemable,
        rect: CGRect
    ) {
        DispatchQueue.global(qos: .userInitiated).sync {
            switch item {
            case let project as ProjectEntity:
                projectAbsoluteRectMap[project] = rect
            case let dailyTodoList as DailyTodoListEntity:
                dailyTodoListAbsoluteRectMap[dailyTodoList] = rect
            case let todo as TodoEntity:
                todoAbsoluteRectMap[todo] = rect
            default:
                break
            }
        }
    }

    public func unregisterAbsoluteRect(_ item: DragDropItemable) {
        DispatchQueue.global(qos: .userInitiated).sync {
            switch item {
            case let project as ProjectEntity:
                projectAbsoluteRectMap.removeValue(forKey: project)
            case let dailyTodoList as DailyTodoListEntity:
                dailyTodoListAbsoluteRectMap.removeValue(forKey: dailyTodoList)
            case let todo as TodoEntity:
                todoAbsoluteRectMap.removeValue(forKey: todo)
            default:
                break
            }
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
        guard let todo = item as? TodoEntity else {
            return
        }
        dragged = nil
        Task {
            if let targetTodo = getTargetTodo(touchLocation: touchLocation) {
                try await Self.todoUseCase.swapTodos(
                    todo,
                    targetTodo
                )
                return
            }
            if let targetProject = getTargetProject(touchLocation: touchLocation),
               targetProject === todo.project.value {
                try await Self.todoUseCase.moveToProject(todo: todo)
                return
            }
            if let targetDailyTodoList = getTargetDailyTodoList(touchLocation: touchLocation) {
                try await Self.todoUseCase.moveToDaily(
                    todo: todo,
                    dailyTodoList: targetDailyTodoList
                )
                return
            }
        }
    }

    private func getTargetProject(touchLocation: CGPoint) -> ProjectEntity? {
        projectAbsoluteRectMap
            .first(where: { $1.contains(touchLocation) })?
            .key
    }

    private func getTargetDailyTodoList(touchLocation: CGPoint) -> DailyTodoListEntity? {
        dailyTodoListAbsoluteRectMap
            .first(where: { $1.contains(touchLocation) })?
            .key
    }

    private func getTargetTodo(touchLocation: CGPoint) -> TodoEntity? {
        todoAbsoluteRectMap
            .first(where: { $1.contains(touchLocation) })?
            .key
    }
}
