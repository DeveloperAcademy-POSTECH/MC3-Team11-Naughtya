//
//  DefaultProjectUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

struct DefaultProjectUseCase: ProjectUseCase {
    private static let projectStore: ProjectStore = .shared
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
            endedAt: endedAt
        )
        Task {
            let record = try await Self.cloudKitManager.create(project.record)
            project.recordId = record.id
        }
        Self.projectStore.projects.append(project)
        return project
    }

    func readList() async throws -> [ProjectEntity] {
        Self.projectStore.projects
    }

    func readItem(category: String) async throws -> ProjectEntity {
        Self.projectStore.projects.first { $0.category.value == category }!
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
        guard let index = Self.projectStore.projects
            .firstIndex(where: { $0.category.value == project.category.value }) else {
            throw DomainError(message: "프로젝트를 찾을 수 없습니다.")
        }
        Self.projectStore.projects.remove(at: index)
        try await Self.cloudKitManager.delete(project.recordId)
    }

    private func validateNotEmptyCategory(_ category: String) -> Bool {
        !category.isEmpty
    }

    private func validateUniqueCategory(_ category: String) -> Bool {
        Self.projectStore.projects.first { $0.category.value == category } == nil
    }
}
