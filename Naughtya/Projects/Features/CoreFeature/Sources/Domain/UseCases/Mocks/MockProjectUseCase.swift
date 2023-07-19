//
//  MockProjectUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

final class MockProjectUseCase: ProjectUseCase {
    private static let store: ProjectStore = .shared

    private var projects: [ProjectEntity] {
        get {
            Self.store.projects
        }
        set {
            Self.store.projects = newValue
        }
    }

    func create(
        category: String,
        goals: String? = nil,
        startedAt: Date? = nil,
        endedAt: Date? = nil
    ) throws -> ProjectEntity {
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

    func readList() throws -> [ProjectEntity] {
        projects
    }

    func readItem(category: String) throws -> ProjectEntity {
        projects.first { $0.category == category }!
    }

    func update(
        _ project: ProjectEntity,
        goals: String? = nil,
        startedAt: Date? = nil,
        endedAt: Date? = nil
    ) throws -> ProjectEntity {
        defer { Self.store.update() }
        project.goals = goals
        project.startedAt = startedAt
        project.endedAt = endedAt
        return project
    }

    func delete(todo: TodoEntity) throws {
        defer { Self.store.update() }
        projects
            .first { $0 === todo.project }?
            .todos
            .removeAll(where: { $0 === todo })
    }

    private func validateNotEmptyCategory(_ category: String) -> Bool {
        !category.isEmpty
    }

    private func validateUniqueCategory(_ category: String) -> Bool {
        projects.first { $0.category == category } == nil
    }
}
