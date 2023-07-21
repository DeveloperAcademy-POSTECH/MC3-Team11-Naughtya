//
//  DashboardViewModel.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import Combine

@MainActor
public final class DashboardViewModel: ObservableObject {
    private static let projectStore: ProjectStore = .shared

    @Published public var projects: [ProjectModel] = []
    @Published public var isSelected = false
    private var cancellable = Set<AnyCancellable>()

    public init() {
        setupFetchingData()
    }

    private func setupFetchingData() {
        Self.projectStore.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [unowned self] _ in
                projects = Self.projectStore.projects
                    .map { .from(entity: $0) }
            }
            .store(in: &cancellable)
    }
}
