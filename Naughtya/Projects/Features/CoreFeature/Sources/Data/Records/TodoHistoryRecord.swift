//
//  TodoHistoryRecord.swift
//  CoreFeature
//
//  Created by byo on 2023/07/31.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import CloudKit

struct TodoHistoryRecord: Recordable {
    static var recordType: CloudKitRecordType = .todoHistory

    let id: CKRecord.ID?
    let dailyTodoList: CKRecord.Reference?
    let isCompleted: Int
    let createdAt: Date?

    var dictionary: [String: Any?] {
        [
            "dailyTodoList": dailyTodoList,
            "isCompleted": isCompleted,
            "createdAt": createdAt
        ]
    }

    static func build(ckRecord: CKRecord) -> TodoHistoryRecord {
        TodoHistoryRecord(
            id: ckRecord.recordID,
            dailyTodoList: ckRecord["dailyTodoList"] as? CKRecord.Reference,
            isCompleted: ckRecord["isCompleted"] as? Int ?? .init(),
            createdAt: ckRecord["createdAt"] as? Date
        )
    }
}

extension TodoHistoryEntity: RecordConvertable {
    var record: TodoHistoryRecord {
        TodoHistoryRecord(
            id: recordId,
            dailyTodoList: dailyTodoList?.reference,
            isCompleted: isCompleted ? 1 : 0,
            createdAt: createdAt
        )
    }
}
