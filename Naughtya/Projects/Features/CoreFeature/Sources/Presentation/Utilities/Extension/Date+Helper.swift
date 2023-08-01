//
//  Date+Helper.swift
//  CoreFeature
//
//  Created by byo on 2023/07/19.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public extension Date {
    private static let oneDayTimeInterval: TimeInterval = 24 * 60 * 60

    func isSame(_ other: Date) -> Bool {
        getDateString() == other.getDateString()
    }

    func getDateString(_ dateFormat: String? = nil) -> String {
        let dateFormatter = Self.getDateFormatter(dateFormat)
        return dateFormatter.string(from: self)
    }

    func getOneDayBefore() -> Self {
        addingTimeInterval(-Self.oneDayTimeInterval)
    }

    func getOneDayAfter() -> Self {
        addingTimeInterval(Self.oneDayTimeInterval)
    }

    func dDayCalculater(projectEndDay: Date) -> String {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let projectEndDate = calendar.startOfDay(for: projectEndDay)

        let components = calendar.dateComponents([.day], from: currentDate, to: projectEndDate)

        if let days = components.day {
            if days == 0 {
                return "D-day"
            } else if days > 0 {
                return "D-\(days)"
            } else {
                return "D+\(-days)"
            }
        } else {
            return "날짜 계산 오류"
        }
    }

    static var today: Self {
        let date = Date.now
        return .parse(date.getDateString())
    }

    static func parse(
        _ string: String,
        dateFormat: String? = nil
    ) -> Self {
        let dateFormatter = Self.getDateFormatter(dateFormat)
        guard let date = dateFormatter.date(from: string) else {
            return .now
        }
        return date
    }

    static func getRandomDate(
        start: String,
        end: String,
        dateFormat: String? = nil
    ) -> Date {
        let date1 = Date.parse(start, dateFormat: dateFormat)
        let date2 = Date.parse(end, dateFormat: dateFormat)
        return .getRandomDate(start: date1, end: date2)
    }

    static func getRandomDate(
        start: Date,
        end: Date
    ) -> Date {
        var date1 = start
        var date2 = end
        if date2 < date1 {
            let temp = date1
            date1 = date2
            date2 = temp
        }
        let span = TimeInterval.random(in: date1.timeIntervalSinceNow ... date2.timeIntervalSinceNow)
        return Date(timeIntervalSinceNow: span)
    }

    private static func getDateFormatter(_ dateFormat: String? = nil) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat ?? "yyyy-MM-dd"
        return dateFormatter
    }
}
