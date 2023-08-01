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
    private static let localStore: LocalStore = .shared
    private static let cloudKitManager: CloudKitManager = .shared

    public internal(set) var recordId: CKRecord.ID?
    public let dateString: String
    public let todos: CurrentValueSubject<[TodoEntity], Never>
    private var cancellable = Set<AnyCancellable>()

    public init(
        recordId: CKRecord.ID? = nil,
        dateString: String,
        todos: [TodoEntity] = []
    ) {
        self.recordId = recordId
        self.dateString = dateString
        self.todos = .init(todos)
        setupUpdatingStore()
    }

    public var id: String {
        dateString
    }

    public var date: Date {
        .parse(dateString)
    }

    public var dateTitle: String {
        date.getDateString("yyyy.MM.dd")
    }

    private func setupUpdatingStore() {
        todos
            .debounce(
                for: .milliseconds(100),
                scheduler: DispatchQueue.global(qos: .userInitiated)
            )
            .sink { _ in
                Self.localStore.update()
            }
            .store(in: &cancellable)

        todos
            .debounce(
                for: .seconds(3),
                scheduler: DispatchQueue.global(qos: .userInitiated)
            )
            .sink { [unowned self] _ in
                Task {
                    try? await Self.cloudKitManager.update(record)
                }
            }
            .store(in: &cancellable)
    }

    public static func == (lhs: DailyTodoListEntity, rhs: DailyTodoListEntity) -> Bool {
        lhs === rhs
    }
}
