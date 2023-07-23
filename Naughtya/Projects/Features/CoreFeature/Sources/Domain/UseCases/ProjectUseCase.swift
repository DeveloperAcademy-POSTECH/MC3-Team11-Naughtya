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
        endedAt: Date?,
        isSelected: Bool,
        isBookmarked: Bool
    ) throws -> ProjectEntity

    func readList() throws -> [ProjectEntity]
    func readItem(category: String) throws -> ProjectEntity

    func update(
        _ project: ProjectEntity,
        goals: String?,
        startedAt: Date?,
        endedAt: Date?
    ) throws -> ProjectEntity

    func toggleSelected(
        _ project: ProjectEntity,
        isSelected: Bool
    ) throws -> ProjectEntity

    func toggleIsBookmarked(
        _ project: ProjectEntity,
        isBookmarked: Bool
    ) throws -> ProjectEntity
}
