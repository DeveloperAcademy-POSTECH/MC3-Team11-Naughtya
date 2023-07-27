//
//  DailyTodoListRecord.swift
//  CoreFeature
//
//  Created by byo on 2023/07/26.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import CloudKit

struct DailyTodoListRecord: Recordable {
    static var recordType: CloudKitRecordType = .dailyTodoList

    let id: CKRecord.ID?
    let dateString: String
    let todos: [CKRecord.Reference]

    var dictionary: [String: Any?] {
        [
            "dateString": dateString,
            "todos": todos
        ]
    }

    var entity: DailyTodoListEntity {
        DailyTodoListEntity(
            recordId: id,
            dateString: dateString,
            todos: []
        )
    }

    static func build(ckRecord: CKRecord) -> DailyTodoListRecord {
        DailyTodoListRecord(
            id: ckRecord.recordID,
            dateString: ckRecord["dateString"] as? String ?? .init(),
            todos: ckRecord["todos"] as? [CKRecord.Reference] ?? .init()
        )
    }
}

extension DailyTodoListEntity: RecordConvertable {
    var record: DailyTodoListRecord {
        DailyTodoListRecord(
            id: recordId,
            dateString: dateString,
            todos: todos.value.references
        )
    }
}
