//
//  ProjectEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import Combine
import CloudKit

public class ProjectEntity: Equatable, Identifiable {
    public internal(set) var recordId: CKRecord.ID?
    public let category: CurrentValueSubject<String, Never>
    public let goals: CurrentValueSubject<String?, Never>
    public let startedAt: CurrentValueSubject<Date?, Never>
    public let endedAt: CurrentValueSubject<Date?, Never>
    public let todos: CurrentValueSubject<[TodoEntity], Never>
    public let deletedTodos: CurrentValueSubject<[TodoEntity], Never>
    public let isSelected: CurrentValueSubject<Bool, Never>
    public let isBookmarked: CurrentValueSubject<Bool, Never>

    public init(
        recordId: CKRecord.ID? = nil,
        category: String,
        goals: String? = nil,
        startedAt: Date? = nil,
        endedAt: Date? = nil,
        todos: [TodoEntity] = [],
        deletedTodos: [TodoEntity] = [],
        isSelected: Bool = false,
        isBookmarked: Bool = false
    ) {
        self.recordId = recordId
        self.category = .init(category)
        self.goals = .init(goals)
        self.startedAt = .init(startedAt)
        self.endedAt = .init(endedAt)
        self.todos = .init(todos)
        self.deletedTodos = .init(deletedTodos)
        self.isSelected = .init(isSelected)
        self.isBookmarked = .init(isBookmarked)
    }

    public var id: String {
        category.value
    }

    public var isEnded: Bool {
        guard let endedAt = endedAt.value else {
            return false
        }
        return endedAt.timeIntervalSinceNow < Date.now.timeIntervalSinceNow
    }

    public static func == (lhs: ProjectEntity, rhs: ProjectEntity) -> Bool {
        lhs === rhs
    }
}
