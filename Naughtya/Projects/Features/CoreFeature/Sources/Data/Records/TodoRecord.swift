//
//  TodoRecord.swift
//  CoreFeature
//
//  Created by byo on 2023/07/25.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import CloudKit

struct TodoRecord: Recordable {
    static let recordType: CloudKitRecordType = .todo

    let id: CKRecord.ID?
    let project: CKRecord.Reference?
    let dailyTodoList: CKRecord.Reference?
    let title: String
    let createdAt: Date
    let histories: [CKRecord.Reference]
    let completedAt: Date?

    var dictionary: [String: Any] {
        var dict = [String: Any]()
        dict["project"] = project
        dict["dailyTodoList"] = dailyTodoList
        dict["title"] = title
        dict["createdAt"] = createdAt
        dict["histories"] = histories
        dict["completedAt"] = completedAt
        return dict
    }

    var entity: TodoEntity {
        TodoEntity(
            recordId: id,
            project: .sample,
            dailyTodoList: nil,
            title: title,
            createdAt: createdAt,
            histories: [],
            completedAt: completedAt
        )
    }

    static func build(ckRecord: CKRecord) -> TodoRecord {
        TodoRecord(
            id: ckRecord.recordID,
            project: ckRecord["project"] as? CKRecord.Reference,
            dailyTodoList: ckRecord["dailyTodoList"] as? CKRecord.Reference,
            title: ckRecord["title"] as? String ?? .init(),
            createdAt: ckRecord["createdAt"] as? Date ?? .init(),
            histories: ckRecord["histories"] as? [CKRecord.Reference] ?? .init(),
            completedAt: ckRecord["completedAt"] as? Date
        )
    }
}

extension TodoEntity: RecordConvertable {
    var record: TodoRecord {
        TodoRecord(
            id: recordId,
            project: project.reference,
            dailyTodoList: nil, // TODO: dailyTodoList?.reference,
            title: title,
            createdAt: createdAt,
            histories: [], // TODO: histories.references,
            completedAt: completedAt
        )
    }
}
