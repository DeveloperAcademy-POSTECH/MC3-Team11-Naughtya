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
    private static let localStore: LocalStore = .shared
    private static let projectUseCase: ProjectUseCase = DefaultProjectUseCase()
    private static let dailyTodoListUseCase: DailyTodoListUseCase = DefaultDailyTodoListUseCase()
    private static let todoUseCase: TodoUseCase = DefaultTodoUseCase()

    private let startDate = "2023-07-01"
    private let endDate = "2023-08-15"
    private let todoTitles = [
        "디벨롭 시키고 싶은 big idea 논의하기",
        "트랜드 키워드 리서치하기",
        "주제 (자기만족)에 대한 데스크 리서치 해오기",
        "회식 어디서 할지 기획하기",
        "맛없는 맥주 마시기",
        "모두가 인게이지 되는 big idea 선정하기",
        "인게이지를 위해 회식 장소 물색하기",
        "란나타이 예약하기",
        "회의 방향성 노션에 시각화 하기",
        "회의 진행 방향 정하기",
        "쥬쥬로 마스코트 만들기",
        "게릴라 인터뷰",
        "포기하지 않고 우리가 만들 앱 주제 정하기",
        "페르소나 인터뷰를 가장해서 쥬쥬 상담하기",
        "노션에 쥬쥬를 분석 정리하기",
        "우선순위, 원씽에 대한 조사하기",
        "페르소나 관련해서 UX자료 찾아보기",
        "페르소나 니즈 파악하기",
        "설정한 주제 페인포인트 파악하기"
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
        let startedAt = Date.getRandomDate(
            start: startDate,
            end: endDate
        )
        let project = try await Self.projectUseCase.create(
            category: String(uuid.prefix(8)),
            goals: uuid,
            startedAt: startedAt,
            endedAt: .getRandomDate(
                start: startedAt.getDateString(),
                end: endDate
            )
        )
        try await createTodos(project: project)
    }

    private func createTodos(project: ProjectEntity) async throws {
        guard let startDate = project.startedAt.value?.getDateString(),
              let endDate = project.endedAt.value?.getDateString() else {
            return
        }
        var date = Date.parse(startDate)
        while !date.isSame(.parse(endDate)) {
            let dateString = date.getDateString()
            let dailyTodoList = Self.localStore.getDailyTodoList(dateString: dateString)
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
           let date = todo.dailyTodoList.value?.date {
            try await Self.todoUseCase.complete(
                todo,
                date: Bool.random() ? date : date.getOneDayAfter()
            )
        }
    }
}
