//
//  ProjectResultEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public class ProjectResultEntity: Codable {
    public let project: ProjectEntity
    public internal(set) var performances: [PerformanceEntity]

    public init(
        project: ProjectEntity,
        performances: [PerformanceEntity] = []
    ) {
        self.project = project
        self.performances = performances
    }
}
