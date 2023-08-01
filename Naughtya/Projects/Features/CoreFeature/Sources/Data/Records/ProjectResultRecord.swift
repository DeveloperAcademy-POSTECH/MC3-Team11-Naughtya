//
//  ProjectResultRecord.swift
//  CoreFeature
//
//  Created by byo on 2023/07/31.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import CloudKit

struct ProjectResultRecord: Recordable {
    static var recordType: CloudKitRecordType = .projectResult

    let id: CKRecord.ID?
    let project: CKRecord.Reference?
    let abilities: [CKRecord.Reference]
    let isGenerated: Int

    var dictionary: [String: Any?] {
        [
            "project": project,
            "abilities": abilities,
            "isGenerated": isGenerated
        ]
    }

    var entity: ProjectResultEntity {
        ProjectResultEntity(
            recordId: id,
            project: .sample,
            abilities: [],
            isGenerated: isGenerated != 0
        )
    }

    static func build(ckRecord: CKRecord) -> ProjectResultRecord {
        ProjectResultRecord(
            id: ckRecord.recordID,
            project: ckRecord["project"] as? CKRecord.Reference,
            abilities: ckRecord["abilities"] as? [CKRecord.Reference] ?? .init(),
            isGenerated: ckRecord["isGenerated"] as? Int ?? .init()
        )
    }
}

extension ProjectResultEntity: RecordConvertable {
    var record: ProjectResultRecord {
        ProjectResultRecord(
            id: recordId,
            project: project.reference,
            abilities: abilities.value.references,
            isGenerated: isGenerated.value ? 1 : 0
        )
    }
}
