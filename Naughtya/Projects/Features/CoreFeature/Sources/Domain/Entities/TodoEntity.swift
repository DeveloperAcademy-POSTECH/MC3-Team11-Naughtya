//
//  TodoEntity.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public class TodoEntity: Codable, Equatable, Identifiable {
    /// 프로젝트
    public unowned let project: ProjectEntity

    /// 데일리
    public unowned var dailyTodoList: DailyTodoListEntity? {
        didSet {
            histories.append(historyStamp)
        }
    }

    /// 제목
    public internal(set) var title: String

    /// 생성 시간
    public internal(set) var createdAt: Date

    /// 히스토리
    public internal(set) var histories: [TodoHistoryEntity]

    /// 완료 시간
    public internal(set) var completedAt: Date? {
        didSet {
            histories.append(historyStamp)
        }
    }

    public init(
        project: ProjectEntity,
        dailyTodoList: DailyTodoListEntity? = nil,
        title: String = "",
        createdAt: Date = .now, // TODO: 더미데이터도 고려하기
        histories: [TodoHistoryEntity] = [],
        completedAt: Date? = nil
    ) {
        self.project = project
        self.dailyTodoList = dailyTodoList
        self.title = title
        self.createdAt = createdAt
        self.histories = histories
        self.completedAt = completedAt
    }

    /// 고유값
    public var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }

    /// 데일리 여부
    public var isDaily: Bool {
        dailyTodoList != nil
    }

    /// 완료 여부
    public var isCompleted: Bool {
        completedAt != nil
    }

    /// 미완료 여부
    public var isBacklog: Bool {
        !isCompleted
    }

    /// 미룸 여부
    public var isDelayed: Bool {
        !isDailyCompleted
    }

    /// 안미룸 여부
    public var isDailyCompleted: Bool {
        guard let firstMovedToDaily = histories.first(where: { $0.dailyTodoList != nil }),
              let firstCompleted = histories.last(where: { $0.isCompleted }) else {
            return false
        }
        return firstMovedToDaily.createdAt.isSame(firstCompleted.createdAt)
    }

    private var historyStamp: TodoHistoryEntity {
        TodoHistoryEntity(
            dailyTodoList: dailyTodoList,
            isCompleted: isCompleted,
            createdAt: completedAt ?? dailyTodoList?.date ?? .now
        )
    }

    public static func == (lhs: TodoEntity, rhs: TodoEntity) -> Bool {
        lhs === rhs
    }
}
