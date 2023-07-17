//
//  TodoUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public protocol TodoUseCase {
    func create(project: Project) async throws -> Todo

    func update(
        _ todo: Todo,
        title: String
    ) async throws -> Todo

    func complete(_ todo: Todo)
    func undoCompleted(_ todo: Todo)
}
