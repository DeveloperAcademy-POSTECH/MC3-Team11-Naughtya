//
//  TodoHistory+Stub.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public extension TodoHistoryEntity {
    static let sampleNotDaily = TodoHistoryEntity(
        isDaily: false,
        isCompleted: false,
        createdAt: .now
    )

    static let sampleDaily = TodoHistoryEntity(
        isDaily: true,
        isCompleted: false,
        createdAt: .now
    )

    static let sampleCompleted = TodoHistoryEntity(
        isDaily: false,
        isCompleted: true,
        createdAt: .now
    )

    static let sampleDailyCompleted = TodoHistoryEntity(
        isDaily: true,
        isCompleted: true,
        createdAt: .now
    )
}
