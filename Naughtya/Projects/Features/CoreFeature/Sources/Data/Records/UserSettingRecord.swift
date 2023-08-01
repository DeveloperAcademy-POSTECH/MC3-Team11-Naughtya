//
//  UserSettingRecord.swift
//  CoreFeature
//
//  Created by byo on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import CloudKit

struct UserSettingRecord: Recordable {
    static let recordType: CloudKitRecordType = .userSetting

    let id: CKRecord.ID?
    let timeToReset: Time
    let projects: [CKRecord.Reference]

    var dictionary: [String: Any?] {
        [
            "hourToReset": timeToReset.hour,
            "minuteToReset": timeToReset.minute,
            "projects": projects
        ]
    }

    var entity: UserSettingEntity {
        UserSettingEntity(
            recordId: id,
            timeToReset: timeToReset,
            projects: []
        )
    }

    static func build(ckRecord: CKRecord) -> UserSettingRecord {
        UserSettingRecord(
            id: ckRecord.recordID,
            timeToReset: Time(
                hour: ckRecord["hourToReset"] as? Int ?? .init(),
                minute: ckRecord["minuteToReset"] as? Int ?? .init()
            ),
            projects: ckRecord["projects"] as? [CKRecord.Reference] ?? .init()
        )
    }
}

extension UserSettingEntity: RecordConvertable {
    var record: UserSettingRecord {
        UserSettingRecord(
            id: recordId,
            timeToReset: timeToReset.value,
            projects: projects.value.references
        )
    }
}
