//
//  DailyTodoListEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/19.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import Combine
import CloudKit

public class DailyTodoListEntity: Equatable, Identifiable {
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy. MM. dd. (E)"
        return dateFormatter
    }()

    public internal(set) var recordId: CKRecord.ID?
    public let dateString: String
    public let todos: CurrentValueSubject<[TodoEntity], Never>

    public init(
        recordId: CKRecord.ID? = nil,
        dateString: String,
        todos: [TodoEntity] = []
    ) {
        self.recordId = recordId
        self.dateString = dateString
        self.todos = .init(todos)
    }

    public var id: String {
        dateString
    }

    public var date: Date {
        .parse(dateString)
    }

    public var dateTitle: String {
        Self.dateFormatter.string(from: date)
    }

    public static func == (lhs: DailyTodoListEntity, rhs: DailyTodoListEntity) -> Bool {
        lhs.dateString == rhs.dateString
    }
}
