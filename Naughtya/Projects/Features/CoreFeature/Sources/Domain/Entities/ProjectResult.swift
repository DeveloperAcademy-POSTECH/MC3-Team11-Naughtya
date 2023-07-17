//
//  ProjectResult.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public class ProjectResult {
    public let project: Project
    public internal(set) var performances: [Performance]

    public init(
        project: Project,
        performances: [Performance] = []
    ) {
        self.project = project
        self.performances = performances
    }
}
