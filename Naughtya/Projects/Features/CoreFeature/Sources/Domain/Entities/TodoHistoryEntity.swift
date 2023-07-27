//
//  TodoHistoryEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import CloudKit

public struct TodoHistoryEntity: Equatable {
    public internal(set) var recordId: CKRecord.ID?
    public let dailyTodoList: DailyTodoListEntity?
    public let isCompleted: Bool
    public let createdAt: Date
}
