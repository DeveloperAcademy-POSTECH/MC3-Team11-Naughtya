//
//  ProjectUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public protocol ProjectUseCase {
    func create(
        category: String,
        goals: String?,
        startedAt: Date?,
        endedAt: Date?
    ) async throws -> Project

    func readList() async throws -> [Project]
    func readItem(category: String) async throws -> Project

    func update(
        _ project: Project,
        goals: String?,
        startedAt: Date?,
        endedAt: Date?
    ) async throws -> Project
}
