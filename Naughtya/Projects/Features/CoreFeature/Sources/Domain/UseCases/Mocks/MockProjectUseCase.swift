//
//  MockProjectUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

final class MockProjectUseCase: ProjectUseCase {
    static let shared: ProjectUseCase = MockProjectUseCase()

    // TODO: Store 필요
    private var projects: [ProjectEntity] = []

    private init() {
    }

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
        projects.append(project)
        return project
    }

    func readList() async throws -> [ProjectEntity] {
        projects
    }

    func readItem(category: String) async throws -> ProjectEntity {
        projects.first { $0.category == category }!
    }

    func update(
        _ project: ProjectEntity,
        goals: String? = nil,
        startedAt: Date? = nil,
        endedAt: Date? = nil
    ) async throws -> ProjectEntity {
        project.goals = goals
        project.startedAt = startedAt
        project.endedAt = endedAt
        return project
    }

    private func validateNotEmptyCategory(_ category: String) -> Bool {
        !category.isEmpty
    }

    private func validateUniqueCategory(_ category: String) -> Bool {
        projects.first { $0.category == category } == nil
    }
}
