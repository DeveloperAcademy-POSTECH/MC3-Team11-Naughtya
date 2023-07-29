//
//  DefaultProjectUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

struct DefaultProjectUseCase: ProjectUseCase {
    private static let localStore: LocalStore = .shared
    private static let todoUseCase: TodoUseCase = DefaultTodoUseCase()
    private static let cloudKitManager: CloudKitManager = .shared

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
            endedAt: endedAt,
            isSelected: true
        )
        Task {
            let record = try? await Self.cloudKitManager.create(project.record)
            project.recordId = record?.id
        }
        Self.localStore.projects.append(project)
        try await Self.todoUseCase.create(
            project: project,
            dailyTodoList: nil
        )
        return project
    }

    func readList() async throws -> [ProjectEntity] {
        Self.localStore.projects
    }

    func readItem(category: String) async throws -> ProjectEntity {
        Self.localStore.projects.first { $0.category.value == category }!
    }

    func update(
        _ project: ProjectEntity,
        category: String,
        goals: String? = nil,
        startedAt: Date? = nil,
        endedAt: Date? = nil
    ) async throws -> ProjectEntity {
        project.category.value = category
        project.goals.value = goals
        project.startedAt.value = startedAt
        project.endedAt.value = endedAt
        return project
    }

    func toggleSelected(
        _ project: ProjectEntity,
        isSelected: Bool
    ) async throws -> ProjectEntity {
        project.isSelected.value = isSelected
        return project
    }

    func toggleIsBookmarked(
        _ project: ProjectEntity,
        isBookmarked: Bool
    ) async throws -> ProjectEntity {
        project.isBookmarked.value = isBookmarked
        return project
    }

    func delete(_ project: ProjectEntity) async throws {
        guard let index = Self.localStore.projects
            .firstIndex(where: { $0.category.value == project.category.value }) else {
            return
        }
        for todo in project.todos.value {
            try await Self.todoUseCase.delete(todo)
        }
        Self.localStore.projects.remove(at: index)
        try? await Self.cloudKitManager.delete(project.recordId)
    }

    func swapProjects(
        _ lhs: ProjectEntity,
        _ rhs: ProjectEntity
    ) {
        guard let index = Self.localStore.projects
            .firstIndex(where: { $0 === rhs }) else {
            return
        }
        Self.localStore.projects.remove(lhs)
        Self.localStore.projects.insert(lhs, at: index)
    }

    private func validateNotEmptyCategory(_ category: String) -> Bool {
        !category.isEmpty
    }

    private func validateUniqueCategory(_ category: String) -> Bool {
        Self.localStore.projects.first { $0.category.value == category } == nil
    }
}
