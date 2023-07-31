//
//  CloudKitObject.swift
//  CoreFeature
//
//  Created by byo on 2023/07/31.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import CloudKit

final class CloudKitObject<Record: Recordable> {
    let records: [Record]
    private let idRecordMap: [CKRecord.ID: Record]
    private let idEntityMap: [CKRecord.ID: Record.Entity]

    init(records: [Record]) {
        self.records = records
        self.idRecordMap = Self.getIdRecordMap(records: records)
        self.idEntityMap = Self.getIdEntityMap(entities: records.map { $0.entity })
    }

    func getRecord(id: CKRecord.ID?) -> Record? {
        guard let id = id else {
            return nil
        }
        return idRecordMap[id]
    }

    func getEntity(id: CKRecord.ID?) -> Record.Entity? {
        guard let id = id else {
            return nil
        }
        return idEntityMap[id]
    }

    private static func getIdRecordMap(records: [Record]) -> [CKRecord.ID: Record] {
        records
            .reduce([CKRecord.ID: Record]()) {
                var dict = $0
                if let id = $1.id {
                    dict[id] = $1
                }
                return dict
            }
    }

    private static func getIdEntityMap(entities: [Record.Entity]) -> [CKRecord.ID: Record.Entity] {
        entities
            .reduce([CKRecord.ID: Record.Entity]()) {
                var dict = $0
                if let id = $1.recordId {
                    dict[id] = $1
                }
                return dict
            }
    }
}
