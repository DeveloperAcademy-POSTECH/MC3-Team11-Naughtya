//
//  DefaultDailyTodoListUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/19.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

struct DefaultDailyTodoListUseCase: DailyTodoListUseCase {
    private static let localStore: LocalStore = .shared
    private static let cloudKitManager: CloudKitManager = .shared

    func create(dateString: String) async throws -> DailyTodoListEntity? {
        guard try await readByDate(dateString: dateString) == nil else {
            return nil
        }
        let dailyTodoList = DailyTodoListEntity(dateString: dateString)
        Task {
            let record = try? await Self.cloudKitManager.create(dailyTodoList.record)
            dailyTodoList.recordId = record?.id
        }
        Self.localStore.dailyTodoLists.append(dailyTodoList)
        return dailyTodoList
    }

    func readByDate(dateString: String) async throws -> DailyTodoListEntity? {
        Self.localStore.getDailyTodoList(dateString: dateString)
    }

    func addTodoToDaily(
        todo: TodoEntity,
        dailyTodoList: DailyTodoListEntity?
    ) async throws {
        guard let dailyTodoList = dailyTodoList else {
            return
        }
        todo.dailyTodoList.value = dailyTodoList
        dailyTodoList.todos.value.remove(todo)
        dailyTodoList.todos.value.append(todo)
    }

    func removeTodoFromDaily(_ todo: TodoEntity) async throws {
        todo.dailyTodoList.value?.todos.value.remove(todo)
        todo.dailyTodoList.value = nil
    }

    func removeUncompletedTodosFromDaily() async throws {
        let todos = Self.localStore.dailyTodoLists
            .flatMap { $0.todos.value }
            .filter { !$0.isCompleted }
        for todo in todos {
            try await removeTodoFromDaily(todo)
        }
    }
}
