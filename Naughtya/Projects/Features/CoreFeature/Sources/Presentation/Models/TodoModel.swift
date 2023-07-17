//
//  TodoModel.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public struct TodoModel: Equatable, Identifiable, Modelable {
    public let entity: TodoEntity
    public let id: UUID
    public let title: String?
    public let createdAt: Date
    public let isDaily: Bool
    public let histories: [TodoHistoryEntity]
    public let completedAt: Date?
    public let isCompleted: Bool

    public static func from(entity: TodoEntity) -> Self {
        TodoModel(
            entity: entity,
            id: entity.id,
            title: entity.title,
            createdAt: entity.createdAt,
            isDaily: entity.isDaily,
            histories: entity.histories,
            completedAt: entity.completedAt,
            isCompleted: entity.isCompleted
        )
    }
}
