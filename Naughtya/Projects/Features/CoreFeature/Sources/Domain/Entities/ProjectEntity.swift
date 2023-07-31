//
//  ProjectEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import Combine
import CloudKit

public class ProjectEntity: Equatable, Identifiable {
    private static let localStore: LocalStore = .shared
    private static let cloudKitManager: CloudKitManager = .shared

    public internal(set) var recordId: CKRecord.ID?
    public let category: CurrentValueSubject<String, Never>
    public let goals: CurrentValueSubject<String?, Never>
    public let startedAt: CurrentValueSubject<Date?, Never>
    public let endedAt: CurrentValueSubject<Date?, Never>
    public let todos: CurrentValueSubject<[TodoEntity], Never>
    public let deletedTodos: CurrentValueSubject<[TodoEntity], Never>
    public let isSelected: CurrentValueSubject<Bool, Never>
    public let isBookmarked: CurrentValueSubject<Bool, Never>
    private var cancellable = Set<AnyCancellable>()

    public init(
        recordId: CKRecord.ID? = nil,
        category: String,
        goals: String? = nil,
        startedAt: Date? = nil,
        endedAt: Date? = nil,
        todos: [TodoEntity] = [],
        deletedTodos: [TodoEntity] = [],
        isSelected: Bool = false,
        isBookmarked: Bool = false
    ) {
        self.recordId = recordId
        self.category = .init(category)
        self.goals = .init(goals)
        self.startedAt = .init(startedAt)
        self.endedAt = .init(endedAt)
        self.todos = .init(todos)
        self.deletedTodos = .init(deletedTodos)
        self.isSelected = .init(isSelected)
        self.isBookmarked = .init(isBookmarked)
        setupUpdatingStore()
    }

    public var id: String {
        category.value
    }

    public var isEnded: Bool {
        guard let endedAt = endedAt.value else {
            return false
        }
        return endedAt.timeIntervalSinceNow < Date.now.timeIntervalSinceNow
    }

    private func setupUpdatingStore() {
        let publisher = Publishers
            .MergeMany(
                category
                    .map { _ in () }
                    .eraseToAnyPublisher(),
                goals
                    .map { _ in () }
                    .eraseToAnyPublisher(),
                startedAt
                    .map { _ in () }
                    .eraseToAnyPublisher(),
                endedAt
                    .map { _ in () }
                    .eraseToAnyPublisher(),
                todos
                    .map { _ in () }
                    .eraseToAnyPublisher(),
                deletedTodos
                    .map { _ in () }
                    .eraseToAnyPublisher(),
                isSelected
                    .map { _ in () }
                    .eraseToAnyPublisher(),
                isBookmarked
                    .map { _ in () }
                    .eraseToAnyPublisher()
            )

        publisher
            .debounce(
                for: .milliseconds(100),
                scheduler: DispatchQueue.global(qos: .userInitiated)
            )
            .sink {
                Self.localStore.update()
            }
            .store(in: &cancellable)

        publisher
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

    public static func == (lhs: ProjectEntity, rhs: ProjectEntity) -> Bool {
        lhs === rhs
    }
}
