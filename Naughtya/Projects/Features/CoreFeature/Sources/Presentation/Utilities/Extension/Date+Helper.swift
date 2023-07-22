//
//  Date+Helper.swift
//  CoreFeature
//
//  Created by byo on 2023/07/19.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public extension Date {
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    private static let oneDayTimeInterval: TimeInterval = 24 * 60 * 60

    func isSame(_ other: Date) -> Bool {
        getDateString() == other.getDateString()
    }

    func getDateString() -> String {
        Self.dateFormatter.string(from: self)
    }

    func getOneDayBefore() -> Self {
        addingTimeInterval(-Self.oneDayTimeInterval)
    }

    func getOneDayAfter() -> Self {
        addingTimeInterval(Self.oneDayTimeInterval)
    }

    static var today: Self {
        let date = Date.now
        return .parse(date.getDateString())
    }

    static func parse(_ string: String) -> Self {
        guard let date = Self.dateFormatter.date(from: string) else {
            return Date()
        }
        return date
    }

    static func getRandomDate(start: String, end: String) -> Date {
        let date1 = Date.parse(start)
        let date2 = Date.parse(end)
        return .getRandomDate(start: date1, end: date2)
    }

    static func getRandomDate(start: Date, end: Date) -> Date {
        var date1 = start
        var date2 = end
        if date2 < date1 {
            let temp = date1
            date1 = date2
            date2 = temp
        }
        let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)
        return Date(timeIntervalSinceNow: span)
    }
}
