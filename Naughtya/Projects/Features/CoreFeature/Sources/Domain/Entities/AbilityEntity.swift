//
//  AbilityEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import CloudKit

public struct AbilityEntity: Equatable, Identifiable {
    public internal(set) var recordId: CKRecord.ID?
    public let id: UUID = .init()
    public let category: AbilityCategory
    public let title: String
    public var todos: [TodoEntity]
}
