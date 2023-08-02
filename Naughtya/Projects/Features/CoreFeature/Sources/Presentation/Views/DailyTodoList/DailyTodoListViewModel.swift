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
    private static let localStore: LocalStore = .shared
    private static let dailyTodoListUseCase: DailyTodoListUseCase = DefaultDailyTodoListUseCase()

    @Published public var dailyTodoList: DailyTodoListModel?
    @Published public var isTodayFetched = false
    private var cancellable = Set<AnyCancellable>()

    public init() {
        setupFetchingData()
    }

    public var dateTitle: String {
        dailyTodoList?.dateTitle ?? ""
    }

    public func fetchTodayIfNeeded() {
        guard !isTodayFetched else {
            return
        }
        isTodayFetched = true
        let dateString = Date.today.getDateString()
        fetchDailyTodoList(dateString: dateString)
    }

    public func gotoOneDayBefore() {
        guard let oneDayBefore = dailyTodoList?.date.getOneDayBefore() else {
            return
        }
        dailyTodoList = nil
        fetchDailyTodoList(dateString: oneDayBefore.getDateString())
    }

    public func gotoOneDayAfter() {
        guard let oneDayAfter = dailyTodoList?.date.getOneDayAfter() else {
            return
        }
        dailyTodoList = nil
        fetchDailyTodoList(dateString: oneDayAfter.getDateString())
    }

    public func gotoDate(_ date: Date) {
        let dateString = date.getDateString()
        dailyTodoList = nil
        fetchDailyTodoList(dateString: dateString)
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
                guard let dateString = dailyTodoList?.dateString else {
                    return
                }
                fetchDailyTodoList(dateString: dateString)
            }
            .store(in: &cancellable)
    }

    private func fetchDailyTodoList(dateString: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let `self` = self else {
                return
            }
            Task {
                if let existing = try await Self.dailyTodoListUseCase.readByDate(dateString: dateString) {
                    self.dailyTodoList = .from(entity: existing)
                } else if let new = try await Self.dailyTodoListUseCase.create(dateString: dateString) {
                    self.dailyTodoList = .from(entity: new)
                }
                Self.localStore.currentDailyTodoList = self.dailyTodoList?.entity
            }
        }
    }
}
