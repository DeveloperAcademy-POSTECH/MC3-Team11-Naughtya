//
//  ProjectStore.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public final class ProjectStore: ObservableObject {
    public static let shared: ProjectStore = .init()

    @Published public var projects: [ProjectEntity] = []

    private init() {
    }

    public func update() {
        objectWillChange.send()
    }
}
