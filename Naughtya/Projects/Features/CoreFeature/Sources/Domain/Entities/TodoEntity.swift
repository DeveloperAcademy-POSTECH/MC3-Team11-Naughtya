//
//  TodoEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public class TodoEntity: Equatable, Identifiable {
    public unowned let project: ProjectEntity
    public internal(set) var title: String?
    public internal(set) var createdAt: Date
    public internal(set) var isDaily: Bool
    public internal(set) var histories: [TodoHistoryEntity]
    public internal(set) var completedAt: Date?

    public init(
        project: ProjectEntity,
        title: String? = nil,
        createdAt: Date = .now,
        isDaily: Bool,
        histories: [TodoHistoryEntity] = [],
        completedAt: Date? = nil
    ) {
        self.project = project
        self.title = title
        self.createdAt = createdAt
        self.isDaily = isDaily
        self.histories = histories
        self.completedAt = completedAt
    }

    public var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }

    public var isCompleted: Bool {
        completedAt != nil
    }

    public func swap(_ other: TodoEntity) {
        defer { isDaily = other.isDaily }
        guard let myIndex = project.todos.firstIndex(of: self),
              let otherIndex = project.todos.firstIndex(of: other) else {
            return
        }
        let mine = project.todos[myIndex]
        project.todos.remove(at: myIndex)
        project.todos.insert(mine, at: otherIndex)
    }

    public static func == (lhs: TodoEntity, rhs: TodoEntity) -> Bool {
        lhs === rhs
    }
}
