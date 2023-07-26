//
//  RecordConvertable.swift
//  CoreFeature
//
//  Created by byo on 2023/07/26.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import CloudKit

protocol RecordConvertable {
    associatedtype Record: Recordable

    var recordId: CKRecord.ID? { get }
    var record: Record { get }
}
