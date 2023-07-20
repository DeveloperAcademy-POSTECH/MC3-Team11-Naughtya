//
//  Date+Helper.swift
//  CoreFeature
//
//  Created by byo on 2023/07/19.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public extension Date {
    private static let calendar: Calendar = .current
    private static let oneDayTimeInterval: TimeInterval = 24 * 60 * 60

    func isSame(_ other: Date) -> Bool {
        let myComponents = Self.calendar.dateComponents([.year, .month, .day], from: self)
        let otherComponents = Self.calendar.dateComponents([.year, .month, .day], from: other)
        return myComponents == otherComponents
    }

    func getYesterday() -> Self {
        addingTimeInterval(-Self.oneDayTimeInterval)
    }

    func getTomorrow() -> Self {
        addingTimeInterval(Self.oneDayTimeInterval)
    }
}
