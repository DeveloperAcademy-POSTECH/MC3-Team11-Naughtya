//
//  ProjectRecord.swift
//  CoreFeature
//
//  Created by byo on 2023/07/25.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import CloudKit

public struct ProjectRecord: Recordable {
    public static let recordType: CloudKitRecordType = .project

    public let id: CKRecord.ID?
    public let category: String
    public let goals: String?
    public let startedAt: Date?
    public let endedAt: Date?
    public let todos: [String]
    public let deletedTodos: [String]
    public let isSelected: Int
    public let isBookmarked: Int

    public var entity: ProjectEntity {
        ProjectEntity(
            recordId: id,
            category: category,
            goals: goals,
            startedAt: startedAt,
            endedAt: endedAt,
            todos: [],
            deletedTodos: [],
            isSelected: isSelected > 0,
            isBookmarked: isBookmarked > 0
        )
    }

    public var dictionary: [String: Any] {
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

    static public func build(ckRecord: CKRecord) -> ProjectRecord {
        ProjectRecord(
            id: ckRecord.recordID,
            category: ckRecord["category"] as? String ?? .init(),
            goals: ckRecord["goals"] as? String,
            startedAt: ckRecord["startedAt"] as? Date,
            endedAt: ckRecord["endedAt"] as? Date,
            todos: ckRecord["todos"] as? [String] ?? .init(),
            deletedTodos: ckRecord["deletedTodos"] as? [String] ?? .init(),
            isSelected: ckRecord["isSelected"] as? Int ?? .init(),
            isBookmarked: ckRecord["isBookmarked"] as? Int ?? .init()
        )
    }
}

extension ProjectEntity {
    var record: ProjectRecord {
        ProjectRecord(
            id: recordId,
            category: category,
            goals: goals,
            startedAt: startedAt ?? .init(),
            endedAt: endedAt ?? .init(),
            todos: [],
            deletedTodos: [],
            isSelected: isSelected ? 1 : 0,
            isBookmarked: isBookmarked ? 1 : 0
        )
    }
}
