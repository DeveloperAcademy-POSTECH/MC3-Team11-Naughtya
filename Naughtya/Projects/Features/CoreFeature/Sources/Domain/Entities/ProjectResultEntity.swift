//
//  ProjectResultEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public class ProjectResultEntity: Codable, Equatable {
    public let project: ProjectEntity
    public internal(set) var performances: [PerformanceEntity]

    public init(
        project: ProjectEntity,
        performances: [PerformanceEntity] = []
    ) {
        self.project = project
        self.performances = performances
    }

    public var dailyCompletedTodos: [TodoEntity] {
        project.todos
            .filter { $0.isDailyCompleted }
    }

    public static func == (lhs: ProjectResultEntity, rhs: ProjectResultEntity) -> Bool {
        lhs.project === rhs.project
    }
}
