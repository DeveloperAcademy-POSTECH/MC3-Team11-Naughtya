//
//  TodoHistoryEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public struct TodoHistoryEntity: Codable, Equatable {
    public let isDaily: Bool
    public let isCompleted: Bool
    public let createdAt: Date
}
