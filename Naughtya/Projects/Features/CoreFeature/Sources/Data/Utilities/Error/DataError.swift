//
//  DataError.swift
//  CoreFeature
//
//  Created by byo on 2023/07/27.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

struct DataError: Error {
    let message: String
}

extension DataError {
    static let cloudKitDisabled = DataError(message: "CloudKit is disabled")
}
