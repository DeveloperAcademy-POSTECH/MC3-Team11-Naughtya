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

    public var projectsInSidebar: [ProjectModel] {
        isResultTab ? endedProjects : projectsInProgress
    }

    public var selectedProjectsInProgress: [ProjectModel] {
        projectsInProgress
            .filter { $0.isSelected }
    }

    private var projectsInProgress: [ProjectModel] {
        projects
            // TODO: .filter { !$0.isEnded }
            .sorted { $0.isBookmarked && !$1.isBookmarked }
    }

    private var endedProjects: [ProjectModel] {
        projectResults
            .map { $0.project }
            .sorted {
                guard let lhs = $0.endedAt?.timeIntervalSince1970,
                      let rhs = $1.endedAt?.timeIntervalSince1970 else {
                    return false
                }
                return lhs > rhs
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
                    .first { $0.entity === selectedProjectResult?.entity }
            }
            .store(in: &cancellable)
    }
}

extension DashboardViewModel: ProjectSelectable {
    public func selectProject(_ project: ProjectEntity) {
        guard let projectResult = projectResults
            .first(where: { $0.project.entity === project }) else {
            return
        }
        selectedProjectResult = projectResult
    }
}
