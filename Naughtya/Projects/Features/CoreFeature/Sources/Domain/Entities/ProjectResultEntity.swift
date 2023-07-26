//
//  ProjectResultEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public class ProjectResultEntity: Codable, Equatable, Identifiable {
    public let project: ProjectEntity
    public internal(set) var performances: [PerformanceEntity]

    public init(
        project: ProjectEntity,
        performances: [PerformanceEntity] = []
    ) {
        self.project = project
        self.performances = performances
    }

    public var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }

    public var allTodos: [TodoEntity] {
        project.todos
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
        project.deletedTodos
    }

    public var allTodosSummary: String {
        allTodos
            .reduce("") {
                $0 + "- [\($1.isCompleted ? "v" : " ")] \($1.title)\n"
            }
    }

    public var alldelayedTodosSummary: [String] {
        allTodos
            .filter { $0.isDelayed }
            .map { $0.title }
    }

    public var allUnachievedTodosSummary: [String] {
        allTodos
            .filter { !$0.isCompleted }
            .map { $0.title }
    }
//
//    public var alldelayedTodosSummary: String {
//        allTodos
//            .reduce("") {
//                $0 + "- [\($1.isCompleted ? "v" : " ")] \($1.title)\n"
//            }
//    }
//
//    public var alldeletedTodosSummary: String {
//        allTodos
//            .reduce("") {
//                $0 + "- [\($1.isCompleted ? "v" : " ")] \($1.title)\n"
//            }
//    }

    public static func == (lhs: ProjectResultEntity, rhs: ProjectResultEntity) -> Bool {
        lhs.project === rhs.project
    }
}
