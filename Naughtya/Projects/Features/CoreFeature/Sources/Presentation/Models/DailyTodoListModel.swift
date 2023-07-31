//
//  DailyTodoListModel.swift
//  CoreFeature
//
//  Created by byo on 2023/07/19.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public struct DailyTodoListModel: Modelable {
    public let entity: DailyTodoListEntity
    public let dateString: String
    public let date: Date
    public let dateTitle: String
    public let todos: [TodoModel]

    public var allTodosCount: Int {
        todos.count
    }

    public var incompletedTodosCount: Int {
        todos
            .filter { !$0.isCompleted }
            .count
    }

    public static func from(entity: DailyTodoListEntity) -> Self {
        DailyTodoListModel(
            entity: entity,
            dateString: entity.dateString,
            date: entity.date,
            dateTitle: entity.dateTitle,
            todos: entity.todos.value
                .map { .from(entity: $0) }
        )
    }
}
