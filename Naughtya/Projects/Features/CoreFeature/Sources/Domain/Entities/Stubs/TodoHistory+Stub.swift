//
//  TodoHistory+Stub.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public extension TodoHistory {
    static let sampleNotDaily = TodoHistory(
        isDaily: false,
        isCompleted: false,
        createdAt: .now
    )

    static let sampleDaily = TodoHistory(
        isDaily: true,
        isCompleted: false,
        createdAt: .now
    )

    static let sampleCompleted = TodoHistory(
        isDaily: false,
        isCompleted: true,
        createdAt: .now
    )

    static let sampleDailyCompleted = TodoHistory(
        isDaily: true,
        isCompleted: true,
        createdAt: .now
    )
}
