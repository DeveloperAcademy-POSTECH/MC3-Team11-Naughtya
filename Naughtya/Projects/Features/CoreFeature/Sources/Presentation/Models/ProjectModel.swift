//
//  ProjectModel.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public struct ProjectModel: Equatable, Identifiable, Modelable {
    public let entity: ProjectEntity
    public let category: String
    public let goals: String?
    public let startedAt: Date?
    public let endedAt: Date?
    public let todos: [TodoModel]
    public let coldTodos: [TodoModel]
    public let dailyTodos: [TodoModel]
    public let completedTodos: [TodoModel]

    public var id: String {
        category
    }

    public static func from(entity: ProjectEntity) -> Self {
        ProjectModel(
            entity: entity,
            category: entity.category,
            goals: entity.goals,
            startedAt: entity.startedAt,
            endedAt: entity.endedAt,
            todos: entity.todos
                .map { .from(entity: $0) },
            coldTodos: entity.coldTodos
                .map { .from(entity: $0) },
            dailyTodos: entity.dailyTodos
                .map { .from(entity: $0) },
            completedTodos: entity.completedTodos
                .map { .from(entity: $0) }
        )
    }
}
