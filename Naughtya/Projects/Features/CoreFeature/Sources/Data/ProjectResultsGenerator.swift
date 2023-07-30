//
//  ProjectResultsGenerator.swift
//  CoreFeature
//
//  Created by byo on 2023/07/30.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

final class ProjectResultsGenerator: TimeSchedulable, TasksBatchable {
    private static let projectUseCase: ProjectUseCase = DefaultProjectUseCase()
    private static let projectResultUseCase: ProjectResultUseCase = DefaultProjectResultUseCase()

    let scheduledTime: Time
    let scheduledInterval: TimeInterval = 1

    init(scheduledTime: Time) {
        self.scheduledTime = scheduledTime
    }

    func batchTasks() {
        Task {
            let endedProjects = try await Self.projectUseCase.readList()
                .filter { $0.isEnded }
            for project in endedProjects {
                let projectResult = try await Self.projectResultUseCase.readItem(project: project)
                if projectResult == nil {
                    try await Self.projectResultUseCase.create(project: project)
                }
            }
        }
    }
}
