//
//  DragDropableHash.swift
//  CoreFeature
//
//  Created by byo on 2023/07/28.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public struct DragDropableHash: Hashable {
    let item: DragDropItemable
    let priority: Int

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(item))
        hasher.combine(priority)
    }

    public static func == (lhs: DragDropableHash, rhs: DragDropableHash) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
