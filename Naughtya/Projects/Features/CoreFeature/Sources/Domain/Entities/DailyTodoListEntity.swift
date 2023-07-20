//
//  DailyTodoListEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/19.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public class DailyTodoListEntity: Equatable, Identifiable {
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy. MM. dd. (E)"
        return dateFormatter
    }()

    public let date: Date
    public internal(set) var todos: [TodoEntity]

    public init(
        date: Date = .now,
        todos: [TodoEntity] = []
    ) {
        self.date = date
        self.todos = todos
    }

    public var id: String {
        dateTitle
    }

    public var dateTitle: String {
        Self.dateFormatter.string(from: date)
    }

    public static func == (lhs: DailyTodoListEntity, rhs: DailyTodoListEntity) -> Bool {
        lhs === rhs
    }
}
