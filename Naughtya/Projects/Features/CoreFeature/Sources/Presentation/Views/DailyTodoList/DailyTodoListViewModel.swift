//
//  DailyTodoListViewModel.swift
//  CoreFeature
//
//  Created by byo on 2023/07/19.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import Combine

@MainActor
public final class DailyTodoListViewModel: ObservableObject {
    private static let dailyTodoListStore: DailyTodoListStore = .shared
    private static let dailyTodoListUseCase: DailyTodoListUseCase = MockDailyTodoListUseCase()

    @Published public var dailyTodoList: DailyTodoListModel?
    private var cancellable = Set<AnyCancellable>()

    public init() {
        setupFetchingData()
    }

    public var dateTitle: String {
        dailyTodoList?.dateTitle ?? ""
    }

    public var todos: [TodoModel] {
        dailyTodoList?.todos ?? []
    }

    public func fetchToday() {
        fetchDailyTodoList(date: .now)
    }

    public func gotoYesterday() {
        guard let yesterday = dailyTodoList?.date.getYesterday() else {
            return
        }
        fetchDailyTodoList(date: yesterday)
    }

    public func gotoTomorrow() {
        guard let tomorrow = dailyTodoList?.date.getTomorrow() else {
            return
        }
        fetchDailyTodoList(date: tomorrow)
    }

    private func setupFetchingData() {
        Self.dailyTodoListStore.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [unowned self] _ in
                guard let date = dailyTodoList?.date else {
                    return
                }
                fetchDailyTodoList(date: date)
            }
            .store(in: &cancellable)
    }

    private func fetchDailyTodoList(date: Date) {
        Task {
            if let existing = try Self.dailyTodoListUseCase.readByDate(date) {
                dailyTodoList = .from(entity: existing)
            } else {
                let new = try Self.dailyTodoListUseCase.create(date: date)
                dailyTodoList = .from(entity: new)
            }
        }
    }
}
