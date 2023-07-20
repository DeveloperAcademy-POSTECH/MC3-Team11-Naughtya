//
//  DragDropItemable.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public protocol DragDropItemable: AnyObject {
}

extension TodoEntity: Hashable, DragDropItemable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
