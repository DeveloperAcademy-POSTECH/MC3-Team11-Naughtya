//
//  MockProjectResultUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

struct MockProjectResultUseCase: ProjectResultUseCase {
    func create(project: ProjectEntity) throws -> ProjectResultEntity {
        ProjectResultEntity(project: project)
    }
}
