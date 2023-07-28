//
//  ProjectUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public protocol ProjectUseCase {
    @discardableResult
    func create(
        category: String,
        goals: String?,
        startedAt: Date?,
        endedAt: Date?
    ) async throws -> ProjectEntity

    func readList() async throws -> [ProjectEntity]
    func readItem(category: String) async throws -> ProjectEntity

    func update(
        _ project: ProjectEntity,
        category: String,
        goals: String?,
        startedAt: Date?,
        endedAt: Date?
    ) async throws -> ProjectEntity

    func delete(
        _ project: ProjectEntity
    ) async throws

    func swapProjects(
        _ lhs: ProjectEntity,
        _ rhs: ProjectEntity
    ) async throws

    func toggleSelected(
        _ project: ProjectEntity,
        isSelected: Bool
    ) async throws -> ProjectEntity

    func toggleIsBookmarked(
        _ project: ProjectEntity,
        isBookmarked: Bool
    ) async throws -> ProjectEntity
}
