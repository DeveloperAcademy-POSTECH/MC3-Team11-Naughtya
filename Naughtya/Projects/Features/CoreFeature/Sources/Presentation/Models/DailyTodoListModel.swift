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
    public let date: Date
    public let dateTitle: String
    public let todos: [TodoModel]

    public static func from(entity: DailyTodoListEntity) -> Self {
        DailyTodoListModel(
            entity: entity,
            date: entity.date,
            dateTitle: entity.dateTitle,
            todos: entity.todos
                .map { .from(entity: $0) }
        )
    }
}
