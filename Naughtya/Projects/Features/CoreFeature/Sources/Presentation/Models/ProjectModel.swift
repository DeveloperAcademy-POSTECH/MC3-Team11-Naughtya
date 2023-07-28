//
//  ProjectModel.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public struct ProjectModel: Modelable {
    public let entity: ProjectEntity
    public let category: String
    public let goals: String?
    public let startedAt: Date?
    public let endedAt: Date?
    public let todos: [TodoModel]
    public let isEnded: Bool
    public var isSelected: Bool
    public var isBookmarked: Bool

    public var backlogTodos: [TodoModel] {
        todos.filter { !$0.isDaily }
    }

    public var completedTodos: [TodoModel] {
        todos.filter { $0.isCompleted }
    }

    public static func from(entity: ProjectEntity) -> Self {
        ProjectModel(
            entity: entity,
            category: entity.category.value,
            goals: entity.goals.value,
            startedAt: entity.startedAt.value,
            endedAt: entity.endedAt.value,
            todos: entity.todos.value
                .map { .from(entity: $0) },
            isEnded: entity.isEnded,
            isSelected: entity.isSelected.value,
            isBookmarked: entity.isBookmarked.value
        )
    }
}
