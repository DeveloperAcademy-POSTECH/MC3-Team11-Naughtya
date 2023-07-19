//
//  MockDailyTodoListUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/19.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

final class MockDailyTodoListUseCase: DailyTodoListUseCase {
    private static let projectStore: ProjectStore = .shared
    private static let dailyTodoListStore: DailyTodoListStore = .shared

    private var dailyTodoLists: [DailyTodoListEntity] {
        get {
            Self.dailyTodoListStore.dailyTodoLists
        }
        set {
            Self.dailyTodoListStore.dailyTodoLists = newValue
        }
    }

    func create(date: Date) throws -> DailyTodoListEntity {
        defer { Self.dailyTodoListStore.update() }
        let dailyTodoList = DailyTodoListEntity(date: date)
        dailyTodoLists.append(dailyTodoList)
        return dailyTodoList
    }

    func readByDate(_ date: Date) throws -> DailyTodoListEntity? {
        Self.dailyTodoListStore.getDailyTodoList(date: date)
    }

    func addTodoToDaily(_ todo: TodoEntity) throws {
        defer { updateStores() }
        guard let dailyTodoList = Self.dailyTodoListStore.currentDailyTodoList else {
            return
        }
        todo.dailyTodoList = dailyTodoList
        dailyTodoList.todos.append(todo)
    }

    func removeTodoFromDaily(_ todo: TodoEntity) throws {
        defer { updateStores() }
        todo.dailyTodoList?.todos.removeAll(where: { $0 === todo })
        todo.dailyTodoList = nil
    }

    private func updateStores() {
        Self.projectStore.update()
        Self.dailyTodoListStore.update()
    }
}
