//
//  UserSettingEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import Combine
import CloudKit

public class UserSettingEntity: Equatable, Identifiable {
    private static let localStore: LocalStore = .shared
    private static let cloudKitManager: CloudKitManager = .shared

    public internal(set) var recordId: CKRecord.ID?
    public let timeToReset: CurrentValueSubject<Time, Never>
    public let projects: CurrentValueSubject<[ProjectEntity], Never>
    private var cancellable = Set<AnyCancellable>()

    public init(
        timeToReset: Time,
        projects: [ProjectEntity]
    ) {
        self.timeToReset = .init(timeToReset)
        self.projects = .init(projects)
    }

    public var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }

    private func setupUpdatingStore() {
        let publisher = Publishers
            .MergeMany(
                timeToReset
                    .map { _ in }
                    .eraseToAnyPublisher(),
                projects
                    .map { _ in }
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
            .sink { [unowned self] in
                Task {
                    try? await Self.cloudKitManager.update(record)
                }
            }
            .store(in: &cancellable)
    }

    public static func == (lhs: UserSettingEntity, rhs: UserSettingEntity) -> Bool {
        lhs === rhs
    }
}
