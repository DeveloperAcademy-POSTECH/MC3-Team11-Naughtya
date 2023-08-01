//
//  DefaultProjectResultUseCase.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

struct DefaultProjectResultUseCase: ProjectResultUseCase {
    private static let localStore: LocalStore = .shared
    private static let cloudKitManager: CloudKitManager = .shared

    func create(project: ProjectEntity) async throws -> ProjectResultEntity {
        let projectResult = ProjectResultEntity(project: project)
        Task {
            let record = try? await Self.cloudKitManager.create(projectResult.record)
            projectResult.recordId = record?.id
            let generator = AbilitiesGenerator(projectResult: projectResult)
            let abilities = try await generator.generate()
            projectResult.abilities.value = abilities
            projectResult.isGenerated.value = true
        }
        Self.localStore.projectResults.append(projectResult)
        return projectResult
    }

    func readList() async throws -> [ProjectResultEntity] {
        Self.localStore.projectResults
    }

    func readItem(project: ProjectEntity) async throws -> ProjectResultEntity? {
        Self.localStore.projectResults.first(where: { $0.project === project })
    }
}
