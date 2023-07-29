//
//  CloudKitManager.swift
//  CoreFeature
//
//  Created by byo on 2023/07/25.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import CloudKit

public final class CloudKitManager {
    public static let shared: CloudKitManager = .init()
    private static let projectStore: ProjectStore = .shared
    private static let dailyTodoListStore: DailyTodoListStore = .shared

    public let isEnabled = false

    private lazy var container: CKContainer? = {
        guard isEnabled else {
            return nil
        }
        return CKContainer(identifier: "iCloud.Naughtya.TodoList")
    }()

    private init() {
    }

    private var database: CKDatabase {
        container!.database(with: .private)
    }

    @discardableResult
    public func create<T: Recordable>(_ record: T) async throws -> T {
        do {
            guard isEnabled else {
                throw DataError.cloudKitDisabled
            }
            let ckRecord = CKRecord(recordType: T.recordType.key)
            record.dictionary
                .forEach { key, value in
                    ckRecord.setValue(value, forKey: key)
                }
            let savedRecord = try await database.save(ckRecord)
            printLog(savedRecord)
            return T.build(ckRecord: savedRecord)
        } catch {
            printLog(error)
            throw error
        }
    }

    public func readList<T: Recordable>(
        _ recordType: T.Type,
        predicate: NSPredicate = .init(value: true)
    ) async throws -> [T] {
        do {
            guard isEnabled else {
                throw DataError.cloudKitDisabled
            }
            let query = CKQuery(
                recordType: T.recordType.key,
                predicate: predicate
            )
            let fetchedRecords = try await database.records(matching: query)
            printLog(fetchedRecords)
            return fetchedRecords.matchResults
                .compactMap { try? $0.1.get() }
                .map { T.build(ckRecord: $0) }
        } catch {
            printLog(error)
            throw error
        }
    }

    public func readItem<T: Recordable>(
        _ recordType: T.Type,
        id: CKRecord.ID
    ) async throws -> T {
        do {
            guard isEnabled else {
                throw DataError.cloudKitDisabled
            }
            let fetchedRecord = try await database.record(for: id)
            printLog(fetchedRecord)
            return T.build(ckRecord: fetchedRecord)
        } catch {
            printLog(error)
            throw error
        }
    }

    public func update<T: Recordable>(_ record: T) async throws {
        do {
            guard isEnabled else {
                throw DataError.cloudKitDisabled
            }
            guard let id = record.id else {
                return
            }
            let fetchedRecord = try await database.record(for: id)
            record.dictionary
                .forEach { key, value in
                    fetchedRecord.setValue(value, forKey: key)
                }
            let savedRecord = try await database.save(fetchedRecord)
            printLog(savedRecord)
        } catch {
            printLog(error)
            throw error
        }
    }

    public func delete(_ id: CKRecord.ID?) async throws {
        do {
            guard isEnabled else {
                throw DataError.cloudKitDisabled
            }
            guard let id = id else {
                return
            }
            let deletedId = try await database.deleteRecord(withID: id)
            printLog(deletedId)
        } catch {
            printLog(error)
            throw error
        }
    }

    public func syncWithStores() async throws { // 메서드가 매시브해서 ㅈㅅ
        guard isEnabled else {
            return
        }

        let projectRecords = try await readList(ProjectRecord.self)
        let dailyTodoListRecords = try await readList(DailyTodoListRecord.self)
        let todoRecords = try await readList(TodoRecord.self)
        let projectIdRecordMap = getIdRecordMap(records: projectRecords)
        let dailyTodoListIdRecordMap = getIdRecordMap(records: dailyTodoListRecords)
        let todoIdRecordMap = getIdRecordMap(records: todoRecords)
        let projectIdEntityMap = getIdEntityMap(entities: projectRecords.map { $0.entity })
        let dailyTodoListIdEntityMap = getIdEntityMap(entities: dailyTodoListRecords.map { $0.entity })
        let todoIdEntityMap = getIdEntityMap(entities: todoRecords.map { $0.entity })

        projectIdEntityMap
            .forEach { id, entity in
                guard let record = projectIdRecordMap[id] else {
                    return
                }
                entity.todos.value = record.todos
                    .compactMap { todoIdEntityMap[$0.recordID] }
                entity.deletedTodos.value = record.deletedTodos
                    .compactMap { todoIdEntityMap[$0.recordID] }
            }

        dailyTodoListIdEntityMap
            .forEach { id, entity in
                guard let record = dailyTodoListIdRecordMap[id] else {
                    return
                }
                entity.todos.value = record.todos
                    .compactMap { todoIdEntityMap[$0.recordID] }
            }

        todoIdEntityMap
            .forEach { id, entity in
                guard let record = todoIdRecordMap[id] else {
                    return
                }
                if let projectId = record.project?.recordID,
                   let project = projectIdEntityMap[projectId] {
                    entity.project.value = project
                }
                if let dailyTodoListId = record.dailyTodoList?.recordID,
                   let dailyTodoList = dailyTodoListIdEntityMap[dailyTodoListId] {
                    entity.dailyTodoList.value = dailyTodoList
                }
            }

        Self.projectStore.projects = projectRecords
            .compactMap { $0.id }
            .compactMap { projectIdEntityMap[$0] }

        Self.dailyTodoListStore.dailyTodoLists = dailyTodoListRecords
            .compactMap { $0.id }
            .compactMap { dailyTodoListIdEntityMap[$0] }
    }

    private func printLog(_ item: Any) {
        guard isEnabled else {
            return
        }
        if let error = item as? Error {
            print("🚨 @LOG \(error)")
        } else {
            print("✅ @LOG \(item)")
        }
    }

    private func getIdRecordMap<T: Recordable>(records: [T]) -> [CKRecord.ID: T] {
        records
            .reduce([CKRecord.ID: T]()) {
                var dict = $0
                if let id = $1.id {
                    dict[id] = $1
                }
                return dict
            }
    }

    private func getIdEntityMap<T: RecordConvertable>(entities: [T]) -> [CKRecord.ID: T] {
        entities
            .reduce([CKRecord.ID: T]()) {
                var dict = $0
                if let id = $1.recordId {
                    dict[id] = $1
                }
                return dict
            }
    }
}
