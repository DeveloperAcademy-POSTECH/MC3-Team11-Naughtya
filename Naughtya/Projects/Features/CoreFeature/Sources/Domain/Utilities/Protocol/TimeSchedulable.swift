//
//  TimeSchedulable.swift
//  CoreFeature
//
//  Created by byo on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public protocol TimeSchedulable: AnyObject {
    var scheduledTime: Time { get }
    var scheduledInterval: TimeInterval { get }
}
