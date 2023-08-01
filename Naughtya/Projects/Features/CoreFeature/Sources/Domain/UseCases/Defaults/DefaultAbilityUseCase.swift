//
//  DefaultAbilityUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/08/01.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

struct DefaultAbilityUseCase: AbilityUseCase {
    private static let cloudKitManager: CloudKitManager = .shared

    func create(
        category: AbilityCategory,
        title: String,
        todos: [TodoEntity]
    ) async throws -> AbilityEntity {
        let ability = AbilityEntity(
            category: category,
            title: title,
            todos: todos
        )
        Task {
            let record = try? await Self.cloudKitManager.create(ability.record)
            ability.recordId = record?.id
        }
        return ability
    }
}
