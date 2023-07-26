//
//  ProjectResultEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import Combine
import CloudKit

public class ProjectResultEntity: Equatable, Identifiable {
    public internal(set) var recordId: CKRecord.ID?
    public let project: ProjectEntity
    public let performances: CurrentValueSubject<[PerformanceEntity], Never>

    public init(
        recordId: CKRecord.ID? = nil,
        project: ProjectEntity,
        performances: [PerformanceEntity] = []
    ) {
        self.recordId = recordId
        self.project = project
        self.performances = .init(performances)
    }

    public var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }

    public var allTodos: [TodoEntity] {
        project.todos.value
    }

    public var completedTodos: [TodoEntity] {
        allTodos
            .filter { $0.isCompleted }
    }

    public var backlogTodos: [TodoEntity] {
        allTodos
            .filter { $0.isBacklog }
    }

    public var dailyCompletedTodos: [TodoEntity] {
        allTodos
            .filter { $0.isDailyCompleted }
    }

    public var delayedTodos: [TodoEntity] {
        allTodos
            .filter { $0.isDelayed }
    }

    public var deletedTodos: [TodoEntity] {
        project.deletedTodos.value
    }

    public var allTodosSummary: String {
        allTodos
            .reduce("") {
                $0 + "- [\($1.isCompleted ? "v" : " ")] \($1.title)\n"
            }
    }

    public static func == (lhs: ProjectResultEntity, rhs: ProjectResultEntity) -> Bool {
        lhs.project === rhs.project
    }
}
