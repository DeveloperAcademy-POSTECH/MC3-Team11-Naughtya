//
//  AbilityUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/08/01.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

protocol AbilityUseCase {
    @discardableResult
    func create(
        category: AbilityCategory,
        title: String,
        todos: [TodoEntity]
    ) async throws -> AbilityEntity
}
