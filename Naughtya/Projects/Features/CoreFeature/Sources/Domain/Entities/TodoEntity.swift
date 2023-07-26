//
//  TodoEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import Combine
import CloudKit

public class TodoEntity: Equatable, Identifiable {
    private static let projectStore: ProjectStore = .shared
    private static let dailyTodoListStore: DailyTodoListStore = .shared
    private static let cloudKitManager: CloudKitManager = .shared

    public internal(set) var recordId: CKRecord.ID?
    public let project: CurrentValueSubject<ProjectEntity, Never>
    public let dailyTodoList: CurrentValueSubject<DailyTodoListEntity?, Never>
    public let title: CurrentValueSubject<String, Never>
    public let createdAt: CurrentValueSubject<Date, Never>
    public let histories: CurrentValueSubject<[TodoHistoryEntity], Never>
    public let completedAt: CurrentValueSubject<Date?, Never>
    private var cancellable = Set<AnyCancellable>()

    public init(
        recordId: CKRecord.ID? = nil,
        project: ProjectEntity,
        dailyTodoList: DailyTodoListEntity? = nil,
        title: String = "",
        createdAt: Date = .now, // TODO: 더미데이터도 고려하기
        histories: [TodoHistoryEntity] = [],
        completedAt: Date? = nil
    ) {
        self.recordId = recordId
        self.project = .init(project)
        self.dailyTodoList = .init(dailyTodoList)
        self.title = .init(title)
        self.createdAt = .init(createdAt)
        self.histories = .init(histories)
        self.completedAt = .init(completedAt)
        setupUpdatingStore()
    }

    /// 고유값
    public var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }

    /// 데일리 여부
    public var isDaily: Bool {
        dailyTodoList.value != nil
    }

    /// 완료 여부
    public var isCompleted: Bool {
        completedAt.value != nil
    }

    /// 미완료 여부
    public var isBacklog: Bool {
        !isCompleted
    }

    /// 미룸 여부
    public var isDelayed: Bool {
        !isDailyCompleted
    }

    /// 안미룸 여부
    public var isDailyCompleted: Bool {
        guard let firstMovedToDaily = histories.value.first(where: { $0.dailyTodoList != nil }),
              let firstCompleted = histories.value.last(where: { $0.isCompleted }) else {
            return false
        }
        return firstMovedToDaily.createdAt.isSame(firstCompleted.createdAt)
    }

    private var historyStamp: TodoHistoryEntity {
        TodoHistoryEntity(
            dailyTodoList: dailyTodoList.value,
            isCompleted: isCompleted,
            createdAt: completedAt.value ?? dailyTodoList.value?.date ?? .now
        )
    }

    private func setupUpdatingStore() {
        let publisher = Publishers
            .MergeMany(
                project
                    .map { _ in () }
                    .eraseToAnyPublisher(),
                dailyTodoList
                    .map { _ in () }
                    .eraseToAnyPublisher(),
                title
                    .map { _ in () }
                    .eraseToAnyPublisher(),
                createdAt
                    .map { _ in () }
                    .eraseToAnyPublisher(),
                histories
                    .map { _ in () }
                    .eraseToAnyPublisher(),
                completedAt
                    .map { _ in () }
                    .eraseToAnyPublisher()
            )

        publisher
            .debounce(
                for: .milliseconds(100),
                scheduler: DispatchQueue.global(qos: .userInitiated)
            )
            .sink {
                Self.projectStore.update()
                Self.dailyTodoListStore.update()
            }
            .store(in: &cancellable)

        publisher
            .debounce(
                for: .seconds(3),
                scheduler: DispatchQueue.global(qos: .userInitiated)
            )
            .sink { [unowned self] _ in
                Task {
                    try await Self.cloudKitManager.update(record)
                }
            }
            .store(in: &cancellable)
    }

    public static func == (lhs: TodoEntity, rhs: TodoEntity) -> Bool {
        lhs === rhs
    }
}
