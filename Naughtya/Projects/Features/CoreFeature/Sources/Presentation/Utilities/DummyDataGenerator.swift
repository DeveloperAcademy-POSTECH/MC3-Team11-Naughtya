//
//  DummyDataGenerator.swift
//  CoreFeature
//
//  Created by byo on 2023/07/21.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public final class DummyDataGenerator {
    public static let shared: DummyDataGenerator = .init()
    private static let projectStore: ProjectStore = .shared
    private static let dailyTodoListStore: DailyTodoListStore = .shared
    private static let projectUseCase: ProjectUseCase = DefaultProjectUseCase()
    private static let dailyTodoListUseCase: DailyTodoListUseCase = DefaultDailyTodoListUseCase()
    private static let todoUseCase: TodoUseCase = DefaultTodoUseCase()

    private let startDate = "2023-06-01"
    private let middleDate = "2023-07-01"
    private let endDate = "2023-08-01"
    private let todoTitles = [
        "일어나기",
        "씻기",
        "옷입기",
        "점심먹기",
        "C5가기",
        "세션듣기",
        "저녁먹기",
        "공부하기",
        "술먹기",
        "잠자기"
    ]
    private var areDailyTodoListsCreated = false

    private init() {
    }

    func generate() {
        Task {
            try await createDailyTodoListsIfNeeded()
            try await createProject()
        }
    }

    private func createDailyTodoListsIfNeeded() async throws {
        guard !areDailyTodoListsCreated else {
            return
        }
        areDailyTodoListsCreated = true
        var date = Date.parse(startDate)
        while !date.isSame(.parse(endDate)) {
            let dateString = date.getDateString()
            try await Self.dailyTodoListUseCase.create(dateString: dateString)
            date = date.getOneDayAfter()
        }
    }

    private func createProject() async throws {
        let uuid = UUID().uuidString
        let project = try await Self.projectUseCase.create(
            category: String(uuid.prefix(8)),
            goals: uuid,
            startedAt: .getRandomDate(
                start: startDate,
                end: middleDate
            ),
            endedAt: .getRandomDate(
                start: middleDate,
                end: endDate
            )
        )
        try await createTodos(project: project)
    }

    private func createTodos(project: ProjectEntity) async throws {
        guard let startDate = project.startedAt?.getDateString(),
              let endDate = project.endedAt?.getDateString() else {
            return
        }
        var date = Date.parse(startDate)
        while !date.isSame(.parse(endDate)) {
            let dateString = date.getDateString()
            let dailyTodoList = Self.dailyTodoListStore.getDailyTodoList(dateString: dateString)
            for _ in 0 ..< .random(in: 1 ... 10) {
                try await createTodo(
                    project: project,
                    dailyTodoList: dailyTodoList
                )
            }
            date = date.getOneDayAfter()
        }
    }

    private func createTodo(
        project: ProjectEntity,
        dailyTodoList: DailyTodoListEntity?
    ) async throws {
        let todo = try await Self.todoUseCase.create(
            project: project,
            dailyTodoList: nil
        )
        try await Self.todoUseCase.update(
            todo,
            title: todoTitles.randomElement()!
        )
        if Int.random(in: 0 ..< 5) > 0 {
            try await Self.dailyTodoListUseCase.addTodoToDaily(
                todo: todo,
                dailyTodoList: dailyTodoList
            )
        }
        if Int.random(in: 0 ..< 5) > 0,
           let date = todo.dailyTodoList?.date {
            try await Self.todoUseCase.complete(
                todo,
                date: Bool.random() ? date : date.getOneDayAfter()
            )
        }
    }
}
