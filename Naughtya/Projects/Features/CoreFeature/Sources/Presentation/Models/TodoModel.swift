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
    public let category: String
    public let title: String?
    public let isDaily: Bool
    public let isCompleted: Bool

    public static func from(entity: TodoEntity) -> Self {
        TodoModel(
            entity: entity,
            id: entity.id,
            category: entity.project.category,
            title: entity.title,
            isDaily: entity.isDaily,
            isCompleted: entity.isCompleted
        )
    }
}
