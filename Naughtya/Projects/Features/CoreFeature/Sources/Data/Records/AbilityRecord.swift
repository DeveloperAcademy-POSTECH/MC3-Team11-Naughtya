//
//  AbilityRecord.swift
//  CoreFeature
//
//  Created by byo on 2023/07/31.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import CloudKit

struct AbilityRecord: Recordable {
    static var recordType: CloudKitRecordType = .ability

    let id: CKRecord.ID?
    let category: AbilityCategory?
    let title: String
    let todos: [CKRecord.Reference]

    var dictionary: [String: Any?] {
        [
            "category": category?.rawValue,
            "title": title,
            "todos": todos
        ]
    }

    static func build(ckRecord: CKRecord) -> AbilityRecord {
        AbilityRecord(
            id: ckRecord.recordID,
            category: AbilityCategory(rawValue: ckRecord["category"] as? String ?? .init()),
            title: ckRecord["title"] as? String ?? .init(),
            todos: ckRecord["todos"] as? [CKRecord.Reference] ?? .init()
        )
    }
}

extension AbilityEntity: RecordConvertable {
    var record: AbilityRecord {
        AbilityRecord(
            id: recordId,
            category: category,
            title: title,
            todos: todos.references
        )
    }
}
