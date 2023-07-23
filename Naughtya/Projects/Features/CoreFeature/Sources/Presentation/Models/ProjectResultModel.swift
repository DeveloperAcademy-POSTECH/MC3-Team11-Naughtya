//
//  ProjectResultModel.swift
//  CoreFeature
//
//  Created by byo on 2023/07/24.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public struct ProjectResultModel: Modelable {
    public let entity: ProjectResultEntity
    public let project: ProjectModel
    public let dailyCompletedTodosCount: Int

    public static func from(entity: ProjectResultEntity) -> Self {
        ProjectResultModel(
            entity: entity,
            project: .from(entity: entity.project),
            dailyCompletedTodosCount: entity.dailyCompletedTodosCount
        )
    }
}
