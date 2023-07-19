//
//  TodoEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public class TodoEntity: Equatable, Identifiable {
    public unowned let project: ProjectEntity
    public unowned var dailyTodoList: DailyTodoListEntity?
    public internal(set) var title: String
    public internal(set) var createdAt: Date
    public internal(set) var histories: [TodoHistoryEntity]
    public internal(set) var completedAt: Date?

    public init(
        project: ProjectEntity,
        dailyTodoList: DailyTodoListEntity? = nil,
        title: String = "",
        createdAt: Date = .now,
        histories: [TodoHistoryEntity] = [],
        completedAt: Date? = nil
    ) {
        self.project = project
        self.dailyTodoList = dailyTodoList
        self.title = title
        self.createdAt = createdAt
        self.histories = histories
        self.completedAt = completedAt
    }

    public var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }

    public var isDaily: Bool {
        dailyTodoList != nil
    }

    public var isCompleted: Bool {
        completedAt != nil
    }

    public static func == (lhs: TodoEntity, rhs: TodoEntity) -> Bool {
        lhs === rhs
    }
}
