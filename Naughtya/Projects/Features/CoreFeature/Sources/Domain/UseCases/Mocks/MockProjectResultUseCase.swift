//
//  MockProjectResultUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

struct MockProjectResultUseCase: ProjectResultUseCase {
    private static let projectStore: ProjectStore = .shared

    func create(project: ProjectEntity) async throws -> ProjectResultEntity {
        ProjectResultEntity(project: project)
    }

    func readList() async throws -> [ProjectResultEntity] {
        Self.projectStore.projects
            .filter { $0.isEnded }
            .map {
                ProjectResultEntity(project: $0)
            }
    }
}
