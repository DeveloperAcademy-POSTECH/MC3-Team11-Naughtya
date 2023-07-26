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

    var dictionary: [String: Any] {
        var dict = [String: Any]()
        dict["category"] = category
        dict["goals"] = goals
        dict["startedAt"] = startedAt
        dict["endedAt"] = endedAt
        dict["todos"] = todos
        dict["deletedTodos"] = deletedTodos
        dict["isSelected"] = isSelected
        dict["isBookmarked"] = isBookmarked
        return dict
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
            category: category,
            goals: goals,
            startedAt: startedAt ?? .init(),
            endedAt: endedAt ?? .init(),
            todos: todos.references,
            deletedTodos: deletedTodos.references,
            isSelected: isSelected ? 1 : 0,
            isBookmarked: isBookmarked ? 1 : 0
        )
    }
}
