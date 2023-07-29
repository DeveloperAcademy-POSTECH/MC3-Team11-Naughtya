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
    public let abilities: [AbilityEntity]

    public var projectName: String {
        project.category
    }

    public var daysInProject: Int {
        guard let startedAt = project.startedAt,
              let endedAt = project.endedAt else {
            return 0
        }
        let components = Calendar.current.dateComponents(
            [.day],
            from: startedAt,
            to: endedAt
        )
        return components.day!
    }

    public var abilitiesCount: Int {
        abilities.count
    }

    public var completedPercent: Int {
        Int(round(Double(completedCount) / Double(allTodosCount) * 100))
    }

    public var completedCount: Int {
        project.completedTodos.count
    }

    public var allTodosCount: Int {
        project.todos.count
    }

    public var top3DelayedTodos: [TodoModel] {
        Array(
            project.completedTodos
                .sorted(by: { $0.delayedCount > $1.delayedCount })
                .prefix(3)
        )
    }

    public var uncompletedTodos: [TodoModel] {
        project.todos
            .filter { !$0.isCompleted }
    }

    public static func from(entity: ProjectResultEntity) -> Self {
        ProjectResultModel(
            entity: entity,
            project: .from(entity: entity.project),
            abilities: entity.abilities.value
        )
    }
}
