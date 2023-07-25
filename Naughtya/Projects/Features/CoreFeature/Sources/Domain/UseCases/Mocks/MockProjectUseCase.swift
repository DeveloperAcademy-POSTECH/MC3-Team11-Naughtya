//
//  MockProjectUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

final class MockProjectUseCase: ProjectUseCase {
    private static let projectStore: ProjectStore = .shared

    private var projects: [ProjectEntity] {
        get {
            Self.projectStore.projects
        }
        set {
            Self.projectStore.projects = newValue
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
        project.todos = [
            .buildEmptyTodo(
                project: project,
                title: "placeholder"
            ),
            .buildEmptyTodo(project: project)
        ]
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
        category: String,
        goals: String? = nil,
        startedAt: Date? = nil,
        endedAt: Date? = nil
    ) throws -> ProjectEntity {
        defer { Self.projectStore.update() }
        project.goals = goals
        project.startedAt = startedAt
        project.endedAt = endedAt
        return project
    }

    func toggleSelected(
        _ project: ProjectEntity,
        isSelected: Bool
    ) throws -> ProjectEntity {
        defer { Self.projectStore.update() }
        project.isSelected = isSelected
        return project
    }

    func toggleIsBookmarked(
        _ project: ProjectEntity,
        isBookmarked: Bool
    ) throws -> ProjectEntity {
        defer { Self.projectStore.update() }
        project.isBookmarked = isBookmarked
        return project
    }

    func delete(_ project: ProjectEntity) throws {
        defer { Self.projectStore.update() }
        guard let index = projects.firstIndex(where: { $0.category == project.category }) else {
            throw DomainError(message: "프로젝트를 찾을 수 없습니다.")
        }
        projects.remove(at: index)
    }

    private func validateNotEmptyCategory(_ category: String) -> Bool {
        !category.isEmpty
    }

    private func validateUniqueCategory(_ category: String) -> Bool {
        projects.first { $0.category == category } == nil
    }
}
