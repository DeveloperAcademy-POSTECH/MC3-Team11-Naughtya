//
//  DashboardViewModel.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

@MainActor
public final class DashboardViewModel: ObservableObject {
    private static let projectUseCase: ProjectUseCase = MockProjectUseCase.shared

    @Published public var projects: [ProjectModel] = []
    @Published public var dailyTodos: [TodoModel] = []

    public init() {
        setupFetchingData()
    }

    private func setupFetchingData() {
        // TODO: observing 필요
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [unowned self] _ in
            fetchData()
        }
    }

    private func fetchData() {
        Task {
            projects = try await Self.projectUseCase.readList()
                .map { .from(entity: $0) }
            dailyTodos = projects
                .flatMap { $0.dailyTodos }
        }
    }
}
