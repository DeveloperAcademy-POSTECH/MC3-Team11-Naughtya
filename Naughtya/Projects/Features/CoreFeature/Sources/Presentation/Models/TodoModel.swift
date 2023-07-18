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
    public let category: String
    public let title: String?
    public let isDaily: Bool
    public let isCompleted: Bool

    public var id: ObjectIdentifier {
        entity.id
    }

    public static func from(entity: TodoEntity) -> Self {
        TodoModel(
            entity: entity,
            category: entity.project.category,
            title: entity.title,
            isDaily: entity.isDaily,
            isCompleted: entity.isCompleted
        )
    }
}
