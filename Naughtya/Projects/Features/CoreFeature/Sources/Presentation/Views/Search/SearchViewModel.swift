//
//  SearchViewModel.swift
//  CoreFeature
//
//  Created by byo on 2023/07/20.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import Combine

@MainActor
public final class SearchViewModel: ObservableObject {
    private static let searchManager: SearchManager = .shared
    private static let projectStore: ProjectStore = .shared
    private static let dailyTodoListStore: DailyTodoListStore = .shared
    private static let todoUseCase: TodoUseCase = MockTodoUseCase()

    @Published public var searchedText: String = ""
    @Published public var searchedTodos: [TodoModel] = []
    private var cancellable = Set<AnyCancellable>()

    public init() {
        setupFetchingData()
    }

    public func updateSearchingState() {
        Self.searchManager.isSearching = !searchedText.isEmpty
    }

    public func fetchSearchedTodos() {
        guard !searchedText.isEmpty else {
            return
        }
        Task {
            searchedTodos = try await Self.todoUseCase.readList(searchedText: searchedText)
                .map { .from(entity: $0) }
        }
    }

    private func setupFetchingData() {
        Publishers.CombineLatest(
            Self.projectStore.objectWillChange,
            Self.dailyTodoListStore.objectWillChange
        )
        .receive(on: DispatchQueue.main)
        .sink { _ in
        } receiveValue: { [unowned self] _ in
            fetchSearchedTodos()
        }
        .store(in: &cancellable)
    }
}
