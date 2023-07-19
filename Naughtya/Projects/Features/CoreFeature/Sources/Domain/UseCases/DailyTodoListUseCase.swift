//
//  DailyTodoListUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/19.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public protocol DailyTodoListUseCase {
    @discardableResult
    func create(date: Date) throws -> DailyTodoListEntity

    func readByDate(_ date: Date) throws -> DailyTodoListEntity?
    func addTodoToDaily(_ todo: TodoEntity) throws
    func removeTodoFromDaily(_ todo: TodoEntity) throws
}
