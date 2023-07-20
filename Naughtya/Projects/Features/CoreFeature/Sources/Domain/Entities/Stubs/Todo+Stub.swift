//
//  Todo+Stub.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public extension TodoEntity {
    static let sample = TodoEntity(project: .sample)

    static func buildEmptyTodo(
        project: ProjectEntity,
        dailyTodoList: DailyTodoListEntity? = nil,
        title: String = ""
    ) -> TodoEntity {
        TodoEntity(
            project: project,
            dailyTodoList: dailyTodoList,
            title: title
        )
    }
}
