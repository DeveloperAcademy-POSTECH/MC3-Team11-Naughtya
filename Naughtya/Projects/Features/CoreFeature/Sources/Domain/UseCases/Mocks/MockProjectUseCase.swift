//
//  MockProjectUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

struct MockProjectUseCase: ProjectUseCase {
    private static let projectStore: ProjectStore = .shared

    func create(
        category: String,
        goals: String? = nil,
        startedAt: Date? = nil,
        endedAt: Date? = nil
    ) async throws -> ProjectEntity {
        guard validateNotEmptyCategory(category) else {
            throw DomainError(message: "category 없음")
        }
        guard validateUniqueCategory(category) else {
            throw DomainError(message: "category 중복")
        }
        let project = ProjectEntity(
            category: category,
            goals: goals,
            startedAt: startedAt,
            endedAt: endedAt
        )
        Self.projectStore.projects.append(project)
        return project
    }

    func readList() async throws -> [ProjectEntity] {
        Self.projectStore.projects
    }

    func readItem(category: String) async throws -> ProjectEntity {
        Self.projectStore.projects.first { $0.category == category }!
    }

    func update(
        _ project: ProjectEntity,
        goals: String? = nil,
        startedAt: Date? = nil,
        endedAt: Date? = nil
    ) async throws -> ProjectEntity {
        defer { Self.projectStore.update() }
        project.goals = goals
        project.startedAt = startedAt
        project.endedAt = endedAt
        return project
    }

    private func validateNotEmptyCategory(_ category: String) -> Bool {
        !category.isEmpty
    }

    private func validateUniqueCategory(_ category: String) -> Bool {
        Self.projectStore.projects.first { $0.category == category } == nil
    }
}
