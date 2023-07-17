//
//  Project.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public class Project: Equatable, Identifiable {
    public let category: String
    public internal(set) var goals: String?
    public internal(set) var startedAt: Date?
    public internal(set) var endedAt: Date?
    public internal(set) var todos: [Todo] = []

    public init(
        category: String,
        goals: String? = nil,
        startedAt: Date? = nil,
        endedAt: Date? = nil,
        todos: [Todo] = []
    ) {
        self.category = category
        self.goals = goals
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.todos = todos
    }

    public var id: String {
        category
    }

    public var completedTodos: [Todo] {
        todos.filter { $0.isCompleted }
    }

    public static func == (lhs: Project, rhs: Project) -> Bool {
        lhs === rhs
    }
}
