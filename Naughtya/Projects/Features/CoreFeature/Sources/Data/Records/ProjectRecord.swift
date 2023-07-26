//
//  ProjectRecord.swift
//  CoreFeature
//
//  Created by byo on 2023/07/25.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import CloudKit

struct ProjectRecord: Recordable {
    static let recordType: CloudKitRecordType = .project

    let id: CKRecord.ID?
    let category: String
    let goals: String?
    let startedAt: Date?
    let endedAt: Date?
    let todos: [CKRecord.Reference]
    let deletedTodos: [CKRecord.Reference]
    let isSelected: Int
    let isBookmarked: Int

    var dictionary: [String: Any?] {
        [
            "category": category,
            "goals": goals,
            "startedAt": startedAt,
            "endedAt": endedAt,
            "todos": todos,
            "deletedTodos": deletedTodos,
            "isSelected": isSelected,
            "isBookmarked": isBookmarked
        ]
    }

    var entity: ProjectEntity {
        ProjectEntity(
            recordId: id,
            category: category,
            goals: goals,
            startedAt: startedAt,
            endedAt: endedAt,
            todos: [],
            deletedTodos: [],
            isSelected: isSelected != 0,
            isBookmarked: isSelected != 0
        )
    }

    static func build(ckRecord: CKRecord) -> ProjectRecord {
        ProjectRecord(
            id: ckRecord.recordID,
            category: ckRecord["category"] as? String ?? .init(),
            goals: ckRecord["goals"] as? String,
            startedAt: ckRecord["startedAt"] as? Date,
            endedAt: ckRecord["endedAt"] as? Date,
            todos: ckRecord["todos"] as? [CKRecord.Reference] ?? .init(),
            deletedTodos: ckRecord["deletedTodos"] as? [CKRecord.Reference] ?? .init(),
            isSelected: ckRecord["isSelected"] as? Int ?? .init(),
            isBookmarked: ckRecord["isBookmarked"] as? Int ?? .init()
        )
    }
}

extension ProjectEntity: RecordConvertable {
    var record: ProjectRecord {
        ProjectRecord(
            id: recordId,
            category: category.value,
            goals: goals.value,
            startedAt: startedAt.value ?? .init(),
            endedAt: endedAt.value ?? .init(),
            todos: todos.value.references,
            deletedTodos: deletedTodos.value.references,
            isSelected: isSelected.value ? 1 : 0,
            isBookmarked: isBookmarked.value ? 1 : 0
        )
    }
}
