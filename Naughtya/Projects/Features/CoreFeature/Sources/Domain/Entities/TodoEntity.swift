//
//  TodoEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public class TodoEntity: Codable, Equatable, Identifiable {
    public unowned let project: ProjectEntity
    public unowned var dailyTodoList: DailyTodoListEntity? {
        didSet {
            histories.append(historyStamp)
        }
    }
    public internal(set) var title: String
    public internal(set) var createdAt: Date
    public internal(set) var histories: [TodoHistoryEntity]
    public internal(set) var completedAt: Date? {
        didSet {
            histories.append(historyStamp)
        }
    }

    public init(
        project: ProjectEntity,
        dailyTodoList: DailyTodoListEntity? = nil,
        title: String = "",
        createdAt: Date = .now, // TODO: 더미데이터도 고려하기
        histories: [TodoHistoryEntity] = [],
        completedAt: Date? = nil
    ) {
        self.project = project
        self.dailyTodoList = dailyTodoList
        self.title = title
        self.createdAt = createdAt
        self.histories = histories
        self.completedAt = completedAt
    }

    public var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }

    public var isDaily: Bool {
        dailyTodoList != nil
    }

    public var isCompleted: Bool {
        completedAt != nil
    }

    public var isDailyCompleted: Bool {
        guard let firstMovedToDaily = histories.first(where: { $0.dailyTodoList != nil }),
              let firstCompleted = histories.last(where: { $0.isCompleted }) else {
            return false
        }
        return firstMovedToDaily.createdAt.isSame(firstCompleted.createdAt)
    }

    private var historyStamp: TodoHistoryEntity {
        TodoHistoryEntity(
            dailyTodoList: dailyTodoList,
            isCompleted: isCompleted,
            createdAt: completedAt ?? dailyTodoList?.date ?? .now
        )
    }

    public static func == (lhs: TodoEntity, rhs: TodoEntity) -> Bool {
        lhs === rhs
    }
}
