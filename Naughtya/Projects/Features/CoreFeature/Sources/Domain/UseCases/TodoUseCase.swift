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
        dailyTodoList: DailyTodoListEntity?
    ) throws -> TodoEntity

    func readList(searchedText: String) throws -> [TodoEntity]

    func update(
        _ todo: TodoEntity,
        title: String
    ) throws -> TodoEntity

    func delete(_ todo: TodoEntity) throws
    func complete(_ todo: TodoEntity) throws
    func undoCompleted(_ todo: TodoEntity) throws
    func swap(_ lhs: TodoEntity, _ rhs: TodoEntity) throws
}
