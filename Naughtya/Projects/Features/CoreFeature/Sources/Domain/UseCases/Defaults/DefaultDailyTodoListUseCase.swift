//
//  DefaultDailyTodoListUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/19.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

struct DefaultDailyTodoListUseCase: DailyTodoListUseCase {
    private static let projectStore: ProjectStore = .shared
    private static let dailyTodoListStore: DailyTodoListStore = .shared

    func create(dateString: String) async throws -> DailyTodoListEntity {
        defer { Self.dailyTodoListStore.update() }
        let dailyTodoList = DailyTodoListEntity(dateString: dateString)
        Self.dailyTodoListStore.dailyTodoLists.append(dailyTodoList)
        return dailyTodoList
    }

    func readByDate(dateString: String) async throws -> DailyTodoListEntity? {
        Self.dailyTodoListStore.getDailyTodoList(dateString: dateString)
    }

    func addTodoToDaily(
        todo: TodoEntity,
        dailyTodoList: DailyTodoListEntity?
    ) async throws {
        guard let dailyTodoList = dailyTodoList else {
            return
        }
        defer { updateStores() }
        todo.dailyTodoList = dailyTodoList
        dailyTodoList.todos.remove(todo)
        dailyTodoList.todos.append(todo)
    }

    func removeTodoFromDaily(_ todo: TodoEntity) async throws {
        defer { updateStores() }
        todo.dailyTodoList?.todos.remove(todo)
        todo.dailyTodoList = nil
    }

    private func updateStores() {
        Self.projectStore.update()
        Self.dailyTodoListStore.update()
    }
}
