//
//  DailyTodoListStore.swift
//  CoreFeature
//
//  Created by byo on 2023/07/19.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public final class DailyTodoListStore: ObservableObject {
    public static let shared: DailyTodoListStore = .init()

    @Published public var dailyTodoLists: [DailyTodoListEntity] = []
    public var currentDailyTodoList: DailyTodoListEntity?

    private init() {
    }

    public func getDailyTodoList(date: Date) -> DailyTodoListEntity? {
        let dailyTodoList = dailyTodoLists
            .first(where: { $0.date.isSame(date) })
        currentDailyTodoList = dailyTodoList
        return dailyTodoList
    }

    public func update() {
        objectWillChange.send()
    }
}
