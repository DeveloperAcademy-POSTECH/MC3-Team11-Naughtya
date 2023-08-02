//
//  ProjectResultEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import Combine
import CloudKit

public class ProjectResultEntity: Equatable, Identifiable {
    private static let localStore: LocalStore = .shared
    private static let cloudKitManager: CloudKitManager = .shared

    public internal(set) var recordId: CKRecord.ID?
    public var project: ProjectEntity
    public let abilities: CurrentValueSubject<[AbilityEntity], Never>
    public let isGenerated: CurrentValueSubject<Bool, Never>
    private var cancellable = Set<AnyCancellable>()

    public init(
        recordId: CKRecord.ID? = nil,
        project: ProjectEntity,
        abilities: [AbilityEntity] = [],
        isGenerated: Bool = false
    ) {
        self.recordId = recordId
        self.project = project
        self.abilities = .init(abilities)
        self.isGenerated = .init(isGenerated)
        setupUpdatingStore()
    }

    public var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }

    public var completedTodosSummary: String {
        project.todos.value
            .filter { $0.isCompleted }
            .reduce("") {
                $0 + "- \($1.title.value)\n"
            }
    }

    public var incompletedTodosSummary: String {
        project.todos.value
            .filter { !$0.isCompleted }
            .reduce("") {
                $0 + "- \($1.title.value)\n"
            }
    }

    public var dateStringCompletedTodosMap: [String: [TodoEntity]] {
        project.todos.value
            .filter { $0.isCompleted }
            .reduce([String: [TodoEntity]]()) {
                var result = $0
                guard let dateString = $1.completedAt.value?.getDateString() else {
                    return result
                }
                result[dateString] = (result[dateString] ?? []) + [$1]
                return result
            }
    }

    private func setupUpdatingStore() {
        let publisher = Publishers
            .Merge(
                abilities
                    .map { _ in }
                    .eraseToAnyPublisher(),
                isGenerated
                    .map { _ in }
                    .eraseToAnyPublisher()
            )

        publisher
            .debounce(
                for: .milliseconds(100),
                scheduler: DispatchQueue.global(qos: .userInitiated)
            )
            .sink { _ in
                Self.localStore.update()
            }
            .store(in: &cancellable)

        publisher
            .debounce(
                for: .seconds(3),
                scheduler: DispatchQueue.global(qos: .userInitiated)
            )
            .sink { [unowned self] in
                Task {
                    try? await Self.cloudKitManager.update(record)
                }
            }
            .store(in: &cancellable)
    }

    public static func == (lhs: ProjectResultEntity, rhs: ProjectResultEntity) -> Bool {
        lhs.project === rhs.project
    }
}
