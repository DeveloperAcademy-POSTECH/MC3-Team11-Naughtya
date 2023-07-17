//
//  TodoEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public class TodoEntity: Equatable, Identifiable {
    public let id: UUID = .init()
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

    public var isCompleted: Bool {
        completedAt != nil
    }

    public static func == (lhs: TodoEntity, rhs: TodoEntity) -> Bool {
        lhs === rhs
    }
}
