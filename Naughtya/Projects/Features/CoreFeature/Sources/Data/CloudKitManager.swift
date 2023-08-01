//
//  CloudKitManager.swift
//  CoreFeature
//
//  Created by byo on 2023/07/25.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import CloudKit

final class CloudKitManager {
    static let shared: CloudKitManager = .init()
    private static let localStore: LocalStore = .shared

    let isEnabled = false
    private(set) var isSynchronized = false

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
    func create<T: Recordable>(_ record: T) async throws -> T {
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

    func readList<T: Recordable>(
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

    func readItem<T: Recordable>(
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

    func update<T: Recordable>(_ record: T) async throws {
        do {
            guard isEnabled else {
                throw DataError.cloudKitDisabled
            }
            guard isSynchronized,
                  let id = record.id else {
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

    func delete(_ id: CKRecord.ID?) async throws {
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

    // 메서드가 매시브해서 ㅈㅅ
    func syncWithLocalStore() async throws {
        guard isEnabled else {
            throw DataError.cloudKitDisabled
        }

        let projectsObject = CloudKitObject(records: try await readList(ProjectRecord.self))
        let dailyTodoListsObject = CloudKitObject(records: try await readList(DailyTodoListRecord.self))
        let todosObject = CloudKitObject(records: try await readList(TodoRecord.self))
        let todoHistoriesObject = CloudKitObject(records: try await readList(TodoHistoryRecord.self))
        let projectResultsObject = CloudKitObject(records: try await readList(ProjectResultRecord.self))
        let abilitiesObject = CloudKitObject(records: try await readList(AbilityRecord.self))

        projectsObject.records
            .forEach { record in
                guard let entity = projectsObject.getEntity(id: record.id) else {
                    return
                }
                entity.todos.value = record.todos
                    .compactMap { todosObject.getEntity(id: $0.recordID) }
                entity.deletedTodos.value = record.deletedTodos
                    .compactMap { todosObject.getEntity(id: $0.recordID) }
            }

        dailyTodoListsObject.records
            .forEach { record in
                guard let entity = dailyTodoListsObject.getEntity(id: record.id) else {
                    return
                }
                entity.todos.value = record.todos
                    .compactMap { todosObject.getEntity(id: $0.recordID) }
            }

        todosObject.records
            .forEach { record in
                guard let entity = todosObject.getEntity(id: record.id) else {
                    return
                }
                if let project = projectsObject.getEntity(id: record.project?.recordID) {
                    entity.project.value = project
                }
                if let dailyTodoList = dailyTodoListsObject.getEntity(id: record.dailyTodoList?.recordID) {
                    entity.dailyTodoList.value = dailyTodoList
                }
                entity.histories.value = record.histories
                    .compactMap { todoHistoriesObject.getEntity(id: $0.recordID) }
            }

        projectResultsObject.records
            .forEach { record in
                guard let entity = projectResultsObject.getEntity(id: record.id) else {
                    return
                }
                if let project = projectsObject.getEntity(id: record.project?.recordID) {
                    entity.project = project
                }
                entity.abilities.value = record.abilities
                    .compactMap { abilitiesObject.getEntity(id: $0.recordID) }
            }

        abilitiesObject.records
            .forEach { record in
                guard let entity = abilitiesObject.getEntity(id: record.id) else {
                    return
                }
                entity.todos = record.todos
                    .compactMap { todosObject.getEntity(id: $0.recordID) }
            }

        Self.localStore.projects = projectsObject.records
            .compactMap { projectsObject.getEntity(id: $0.id) }

        Self.localStore.dailyTodoLists = dailyTodoListsObject.records
            .compactMap { dailyTodoListsObject.getEntity(id: $0.id) }

        Self.localStore.projectResults = projectResultsObject.records
            .compactMap { projectResultsObject.getEntity(id: $0.id) }

        isSynchronized = true
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
