//
//  Array+Remove.swift
//  CoreFeature
//
//  Created by byo on 2023/07/24.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public extension Array where Element: Equatable {
    mutating func remove(_ element: Element) {
        guard let index = firstIndex(where: { $0 == element }) else {
            return
        }
        remove(at: index)
    }
}
