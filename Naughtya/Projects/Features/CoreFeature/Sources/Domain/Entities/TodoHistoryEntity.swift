//
//  TodoHistoryEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import CloudKit

public class TodoHistoryEntity: Equatable, Identifiable {
    public internal(set) var recordId: CKRecord.ID?
    public let dailyTodoList: DailyTodoListEntity?
    public let isCompleted: Bool
    public let createdAt: Date?

    public init(
        recordId: CKRecord.ID? = nil,
        dailyTodoList: DailyTodoListEntity?,
        isCompleted: Bool,
        createdAt: Date?
    ) {
        self.recordId = recordId
        self.dailyTodoList = dailyTodoList
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }

    public var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }

    public static func == (lhs: TodoHistoryEntity, rhs: TodoHistoryEntity) -> Bool {
        lhs === rhs
    }
}
