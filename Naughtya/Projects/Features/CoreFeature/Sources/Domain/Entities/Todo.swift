//
//  Todo.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public class Todo: Identifiable {
    public let id: UUID = .init()
    public unowned let project: Project
    public internal(set) var title: String?
    public internal(set) var createdAt: Date
    public internal(set) var histories: [TodoHistory]
    public internal(set) var completedAt: Date?

    public init(
        project: Project,
        title: String? = nil,
        createdAt: Date = .now,
        histories: [TodoHistory] = [],
        completedAt: Date? = nil
    ) {
        self.project = project
        self.title = title
        self.createdAt = createdAt
        self.histories = histories
        self.completedAt = completedAt
    }

    public var isCompleted: Bool {
        completedAt != nil
    }
}
