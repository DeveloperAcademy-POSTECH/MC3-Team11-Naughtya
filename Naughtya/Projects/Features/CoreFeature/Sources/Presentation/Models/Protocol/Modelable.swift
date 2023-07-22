//
//  Modelable.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public protocol Modelable: Codable, Equatable, Identifiable {
    associatedtype Entity: Identifiable

    var entity: Entity { get }
    var id: Entity.ID { get }

    static func from(entity: Entity) -> Self
}

public extension Modelable {
    var id: Entity.ID {
        entity.id
    }
}
