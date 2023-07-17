//
//  Modelable.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public protocol Modelable {
    associatedtype Entity

    var entity: Entity { get }

    static func from(entity: Entity) -> Self
}
