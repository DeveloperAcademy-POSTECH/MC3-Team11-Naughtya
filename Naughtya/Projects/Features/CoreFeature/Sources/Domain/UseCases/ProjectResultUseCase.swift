//
//  ProjectResultUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public protocol ProjectResultUseCase {
    @discardableResult
    func create(project: ProjectEntity) async throws -> ProjectResultEntity

    func readList() async throws -> [ProjectResultEntity]
    func readItem(project: ProjectEntity) async throws -> ProjectResultEntity?
}
