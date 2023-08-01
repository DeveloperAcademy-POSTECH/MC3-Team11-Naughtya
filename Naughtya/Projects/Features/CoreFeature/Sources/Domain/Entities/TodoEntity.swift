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
    private static let localStore: LocalStore = .shared
    private static let todoHistoryUseCase: TodoHistoryUseCase = DefaultTodoHistoryUseCase()
    private static let cloudKitManager: CloudKitManager = .shared

    public internal(set) var recordId: CKRecord.ID?
    public let project: CurrentValueSubject<ProjectEntity, Never>
    public let dailyTodoList: CurrentValueSubject<DailyTodoListEntity?, Never>
    public let title: CurrentValueSubject<String, Never>
    public let createdAt: CurrentValueSubject<Date?, Never>
    public let histories: CurrentValueSubject<[TodoHistoryEntity], Never>
    public let completedAt: CurrentValueSubject<Date?, Never>
    private var cancellable = Set<AnyCancellable>()

    public init(
        recordId: CKRecord.ID? = nil,
        project: ProjectEntity,
        dailyTodoList: DailyTodoListEntity? = nil,
        title: String = "",
        createdAt: Date? = nil,
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
        setupStampingHistory()
    }

    /// 고유값
    public var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }

    /// 미완료 여부
    public var isBacklog: Bool {
        !isCompleted
    }

    /// 데일리 여부
    public var isDaily: Bool {
        dailyTodoList.value != nil
    }

    /// 완료 여부
    public var isCompleted: Bool {
        completedAt.value != nil
    }

    /// 안미룸 여부
    public var isDailyCompleted: Bool {
        isCompleted && delayedCount == 0
    }

    /// 미룸 여부
    public var isDelayed: Bool {
        delayedCount > 0
    }

    /// 미룬 횟수
    public var delayedCount: Int {
        let count = Set(
            histories.value
                .filter { $0.dailyTodoList != nil }
                .compactMap { $0.createdAt?.getDateString() }
        ).count - 1
        return max(count, 0)
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

    private func setupStampingHistory() {
        Publishers
            .Merge(
                dailyTodoList
                    .map { _ in }
                    .eraseToAnyPublisher(),
                completedAt
                    .map { _ in }
                    .eraseToAnyPublisher()
            )
            .debounce(
                for: .milliseconds(100),
                scheduler: DispatchQueue.global(qos: .userInitiated)
            )
            .sink { [unowned self] in
                Task {
                    try await appendHistory()
                }
            }
            .store(in: &cancellable)
    }

    private func appendHistory() async throws {
        let history = try await Self.todoHistoryUseCase.create(
            dailyTodoList: dailyTodoList.value,
            isCompleted: isCompleted,
            createdAt: completedAt.value ?? dailyTodoList.value?.date
        )
        histories.value.append(history)
    }

    public static func == (lhs: TodoEntity, rhs: TodoEntity) -> Bool {
        lhs === rhs
    }
}
