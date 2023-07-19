//
//  TodoUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public protocol TodoUseCase {
    @discardableResult
    func create(
        project: ProjectEntity,
        isDaily: Bool
    ) throws -> TodoEntity

    func update(
        _ todo: TodoEntity,
        title: String
    ) throws -> TodoEntity

    func addToDaily(_ todo: TodoEntity) throws
    func removeFromDaily(_ todo: TodoEntity) throws
    func complete(_ todo: TodoEntity) throws
    func undoCompleted(_ todo: TodoEntity) throws
}
