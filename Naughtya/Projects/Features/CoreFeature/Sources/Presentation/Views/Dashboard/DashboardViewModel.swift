//
//  DashboardViewModel.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import Combine

public final class DashboardViewModel: ObservableObject, ProjectResultSelectable {
    private static let localStore: LocalStore = .shared

    @Published public var projects: [ProjectModel] = []
    @Published public var projectResults: [ProjectResultModel] = []
    @Published public var selectedProjectResult: ProjectResultModel?
    @Published public var selectedTabIndex: Int = 0
    private var cancellable = Set<AnyCancellable>()

    public init() {
        setupFetchingData()
    }

    public var isResultTab: Bool {
        selectedTabIndex == 1
    }

    public var sortedProjects: [ProjectModel] {
        projects
            .filter { !$0.isEnded }
            .sorted { $0.isBookmarked && !$1.isBookmarked }
    }

    public var sortedProjectResults: [ProjectResultModel] {
        projectResults
            .sorted {
                guard let lhs = $0.project.endedAt?.timeIntervalSince1970,
                      let rhs = $1.project.endedAt?.timeIntervalSince1970 else {
                    return false
                }
                return lhs > rhs
            }
    }

    public var selectedProjects: [ProjectModel] {
        sortedProjects
            .filter { $0.isSelected }
    }

    public func selectProjectResult(_ projectResult: ProjectResultModel) {
        guard let projectResult = projectResults
            .first(where: { $0.entity === projectResult.entity }) else {
            return
        }
        if projectResult.entity === selectedProjectResult?.entity {
            selectedProjectResult = nil
        } else {
            selectedProjectResult = projectResult
        }
    }

    private func setupFetchingData() {
        Self.localStore.objectWillChange
            .debounce(
                for: .milliseconds(100),
                scheduler: DispatchQueue.global(qos: .userInitiated)
            )
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [unowned self] _ in
                projects = Self.localStore.projects
                    .map { .from(entity: $0) }
                projectResults = Self.localStore.projectResults
                    .map { .from(entity: $0) }
                selectedProjectResult = projectResults
                    .first(where: { $0.entity === selectedProjectResult?.entity })
            }
            .store(in: &cancellable)
    }
}
