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
        goals: String?,
        startedAt: Date?,
        endedAt: Date?
    ) async throws -> ProjectEntity
}
