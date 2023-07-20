//
//  CGPoint+Operators.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public extension CGPoint {
    static func +(lhs: Self, rhs: Self) -> Self {
        CGPoint(
            x: lhs.x + rhs.x,
            y: lhs.y + rhs.y
        )
    }

    static func -(lhs: Self, rhs: Self) -> Self {
        CGPoint(
            x: lhs.x - rhs.x,
            y: lhs.y - rhs.y
        )
    }
}
