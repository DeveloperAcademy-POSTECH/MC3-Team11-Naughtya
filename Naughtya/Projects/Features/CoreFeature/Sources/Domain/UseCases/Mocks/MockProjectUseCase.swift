//
//  MockProjectUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

struct MockProjectUseCase: ProjectUseCase {
    func create(
        category: String,
        goals: String? = nil,
        startedAt: Date? = nil,
        endedAt: Date? = nil
    ) async throws -> Project {
        Project(
            category: category,
            goals: goals,
            startedAt: startedAt,
            endedAt: endedAt
        )
    }

    func readList() async throws -> [Project] {
        [.sample]
    }

    func readItem(category: String) async throws -> Project {
        .sample
    }

    func update(
        _ project: Project,
        goals: String? = nil,
        startedAt: Date? = nil,
        endedAt: Date? = nil
    ) async throws -> Project {
        project.goals = goals
        project.startedAt = startedAt
        project.endedAt = endedAt
        return project
    }
}
