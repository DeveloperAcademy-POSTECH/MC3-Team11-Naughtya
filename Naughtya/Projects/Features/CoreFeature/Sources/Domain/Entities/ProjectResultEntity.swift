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

    public internal(set) var recordId: CKRecord.ID?
    public let project: ProjectEntity
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

    private func setupUpdatingStore() {
        let publishers = Publishers
            .Merge(
                abilities
                    .map { _ in }
                    .eraseToAnyPublisher(),
                isGenerated
                    .map { _ in }
                    .eraseToAnyPublisher()
            )

        publishers
            .debounce(
                for: .milliseconds(100),
                scheduler: DispatchQueue.global(qos: .userInitiated)
            )
            .sink { _ in
                Self.localStore.update()
            }
            .store(in: &cancellable)
    }

    public static func == (lhs: ProjectResultEntity, rhs: ProjectResultEntity) -> Bool {
        lhs.project === rhs.project
    }
}
