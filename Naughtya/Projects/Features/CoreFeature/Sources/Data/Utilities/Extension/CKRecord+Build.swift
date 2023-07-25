//
//  CKRecord+Build.swift
//  CoreFeature
//
//  Created by byo on 2023/07/25.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import CloudKit

extension CKRecord {
    static func build(_ type: CloudKitRecordType) -> CKRecord {
        CKRecord(recordType: type.key)
    }
}
