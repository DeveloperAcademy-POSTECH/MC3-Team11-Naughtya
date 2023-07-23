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

    public var dailyCompletedTodosCount: Int {
        project.todos
            .filter { $0.isDailyCompleted }
            .count
    }

    public static func == (lhs: ProjectResultEntity, rhs: ProjectResultEntity) -> Bool {
        lhs.project === rhs.project
    }
}
