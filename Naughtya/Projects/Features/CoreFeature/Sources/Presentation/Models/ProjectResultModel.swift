//
//  ProjectResultModel.swift
//  CoreFeature
//
//  Created by byo on 2023/07/24.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public struct ProjectResultModel: Modelable {
    public let entity: ProjectResultEntity
    public let project: ProjectModel
    public let allTodosSummary: String

    public var allTodos: [TodoModel] {
        entity.allTodos
            .map { .from(entity: $0) }
    }

    public var completedTodos: [TodoModel] {
        entity.completedTodos
            .map { .from(entity: $0) }
    }

    public var backlogTodos: [TodoModel] {
        entity.backlogTodos
            .map { .from(entity: $0) }
    }

    public var dailyCompletedTodos: [TodoModel] {
        entity.dailyCompletedTodos
            .map { .from(entity: $0) }
    }

    public var delayedTodos: [TodoModel] {
        entity.delayedTodos
            .map { .from(entity: $0) }
    }

    public var deletedTodos: [TodoModel] {
        entity.deletedTodos
            .map { .from(entity: $0) }
    }

    public static func from(entity: ProjectResultEntity) -> Self {
        ProjectResultModel(
            entity: entity,
            project: .from(entity: entity.project),
            allTodosSummary: entity.allTodosSummary
        )
    }
}
