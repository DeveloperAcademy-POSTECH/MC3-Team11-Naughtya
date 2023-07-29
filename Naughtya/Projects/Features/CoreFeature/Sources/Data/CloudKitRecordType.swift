//
//  CloudKitRecordType.swift
//  CoreFeature
//
//  Created by byo on 2023/07/25.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public enum CloudKitRecordType: String {
    case userSetting
    case project
    case todo
    case dailyTodoList
    case todoHistory
    case projectResult
    case performance

    public var key: String {
        rawValue.capitalized
    }
}
