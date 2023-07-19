//
//  TodoEntity+Sorted.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

extension Collection where Element == TodoEntity {
    func sortedByCompleted() -> [Element] {
        self.sorted {
            if $0.isCompleted && !$1.isCompleted {
                return false
            } else if !$0.isCompleted && $1.isCompleted {
                return true
            } else {
                return false
            }
        }
    }
}
