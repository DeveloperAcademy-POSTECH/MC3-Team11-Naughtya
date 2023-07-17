//
//  ProjectEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public class ProjectEntity: Equatable {
    public let category: String
    public internal(set) var goals: String?
    public internal(set) var startedAt: Date?
    public internal(set) var endedAt: Date?
    public internal(set) var todos: [TodoEntity] = []

    public init(
        category: String,
        goals: String? = nil,
        startedAt: Date? = nil,
        endedAt: Date? = nil,
        todos: [TodoEntity] = []
    ) {
        self.category = category
        self.goals = goals
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.todos = todos
    }

    public var coldTodos: [TodoEntity] {
        todos
            .filter { !$0.isDaily }
            .sortedByCompleted()
    }

    public var dailyTodos: [TodoEntity] {
        todos.filter { $0.isDaily }
    }

    public var completedTodos: [TodoEntity] {
        todos.filter { $0.isCompleted }
    }

    public static func == (lhs: ProjectEntity, rhs: ProjectEntity) -> Bool {
        lhs === rhs
    }
}

// TODO: generic하게 만들기
private extension Collection where Element == TodoEntity {
    func sortedByCompleted() -> [Element] {
        self.sorted {
            if $0.isCompleted && !$1.isCompleted {
                return false
            } else if !$0.isCompleted && $1.isCompleted {
                return true
            } else {
                return false
            }
        }
    }
}
