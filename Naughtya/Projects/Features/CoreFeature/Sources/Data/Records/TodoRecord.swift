//
//  TodoRecord.swift
//  CoreFeature
//
//  Created by byo on 2023/07/25.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import CloudKit

public struct TodoRecord: Recordable {
    public static let recordType: CloudKitRecordType = .todo

    public let id: CKRecord.ID?
    public let project: CKRecord.Reference?
    public let dailyTodoList: CKRecord.Reference?
    public let title: String
    public let createdAt: Date
    public let histories: [String]
    public let completedAt: Date?

    public var entity: TodoEntity {
        TodoEntity(
            project: .sample,
            dailyTodoList: nil,
            title: title,
            createdAt: createdAt,
            histories: [],
            completedAt: completedAt
        )
    }

    public var dictionary: [String: Any] {
        var dict = [String: Any]()
        dict["project"] = project
        dict["dailyTodoList"] = dailyTodoList
        dict["title"] = title
        dict["createdAt"] = createdAt
        dict["histories"] = histories
        dict["completedAt"] = completedAt
        return dict
    }

    public static func build(ckRecord: CKRecord) -> TodoRecord {
        TodoRecord(
            id: ckRecord.recordID,
            project: ckRecord["project"] as? CKRecord.Reference,
            dailyTodoList: ckRecord["dailyTodoList"] as? CKRecord.Reference,
            title: ckRecord["title"] as? String ?? .init(),
            createdAt: ckRecord["createdAt"] as? Date ?? .init(),
            histories: ckRecord["histories"] as? [String] ?? .init(),
            completedAt: ckRecord["completedAt"] as? Date
        )
    }
}

extension TodoEntity {
    var record: TodoRecord {
        TodoRecord(
            id: recordId,
            project: project.recordId
                .map { CKRecord.Reference(recordID: $0, action: .none) },
            dailyTodoList: dailyTodoList?.recordId
                .map { CKRecord.Reference(recordID: $0, action: .none) },
            title: title,
            createdAt: createdAt,
            histories: [],
            completedAt: completedAt
        )
    }
}
