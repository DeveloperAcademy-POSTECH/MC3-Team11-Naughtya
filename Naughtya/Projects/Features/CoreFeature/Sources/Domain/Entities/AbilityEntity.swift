//
//  AbilityEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import CloudKit

public class AbilityEntity: Equatable, Identifiable {
    public internal(set) var recordId: CKRecord.ID?
    public let category: AbilityCategory
    public let title: String
    public internal(set) var todos: [TodoEntity]

    public init(
        recordId: CKRecord.ID? = nil,
        category: AbilityCategory,
        title: String,
        todos: [TodoEntity]
    ) {
        self.recordId = recordId
        self.category = category
        self.title = title
        self.todos = todos
    }

    public var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }

    public static func == (lhs: AbilityEntity, rhs: AbilityEntity) -> Bool {
        lhs === rhs
    }
}
