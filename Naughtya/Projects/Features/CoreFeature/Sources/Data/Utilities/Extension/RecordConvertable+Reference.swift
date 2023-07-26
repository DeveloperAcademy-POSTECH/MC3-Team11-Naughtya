//
//  RecordConvertable+Reference.swift
//  CoreFeature
//
//  Created by byo on 2023/07/26.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import CloudKit

extension RecordConvertable {
    var reference: CKRecord.Reference? {
        guard let id = recordId else {
            return nil
        }
        return CKRecord.Reference(
            recordID: id,
            action: .none
        )
    }
}

extension Collection where Element: RecordConvertable {
    var references: [CKRecord.Reference] {
        self.compactMap { $0.reference }
    }
}
