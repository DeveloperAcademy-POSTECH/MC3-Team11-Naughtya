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

    private let container = CKContainer(identifier: "iCloud.Naughtya.TodoList")

    private init() {
    }

    private var database: CKDatabase {
        container.database(with: .private)
    }

    @discardableResult
    public func create<T: Recordable>(_ record: T) async throws -> T {
        let ckRecord = CKRecord(recordType: T.recordType.key)
        ckRecord.setValuesForKeys(record.dictionary)
        do {
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
        try await withCheckedThrowingContinuation { continuation in
            let query = CKQuery(
                recordType: T.recordType.key,
                predicate: predicate
            )
            database.fetch(withQuery: query) { [unowned self] result in
                switch result {
                case let .success(response):
                    let matchResults = response.matchResults
                    printLog(matchResults)
                    let records = matchResults
                        .compactMap { try? $0.1.get() }
                        .map { T.build(ckRecord: $0) }
                    continuation.resume(returning: records)
                case let .failure(error):
                    printLog(error)
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    public func readItem<T: Recordable>(
        _ recordType: T.Type,
        id: CKRecord.ID
    ) async throws -> T {
        let ckRecord = try await database.record(for: id)
        let record = T.build(ckRecord: ckRecord)
        return record
    }

    public func update<T: Recordable>(_ record: T) async throws {
        guard let id = record.id else {
            return
        }
        let ckRecord = try await database.record(for: id)
        ckRecord.setValuesForKeys(record.dictionary)
        try await database.save(ckRecord)
    }

    public func delete(_ id: CKRecord.ID?) async throws {
        guard let id = id else {
            return
        }
        try await database.deleteRecord(withID: id)
    }

    public func syncWithStores() async throws {
        let projectRecords = try await readList(ProjectRecord.self)
        let todoRecords = try await readList(TodoRecord.self)
        let projectIdRecordMap = getIdRecordMap(records: projectRecords)
        let todoIdRecordMap = getIdRecordMap(records: todoRecords)
        let projectIdEntityMap = getIdEntityMap(entities: projectRecords.map { $0.entity })
        let todoIdEntityMap = getIdEntityMap(entities: todoRecords.map { $0.entity })

        projectIdEntityMap
            .forEach { id, entity in
                guard let record = projectIdRecordMap[id] else {
                    return
                }
                entity.todos = record.todos
                    .compactMap { todoIdEntityMap[$0.recordID] }
                entity.deletedTodos = record.deletedTodos
                    .compactMap { todoIdEntityMap[$0.recordID] }
            }

        todoIdEntityMap
            .forEach { id, entity in
                guard let record = todoIdRecordMap[id],
                      let projectId = record.project?.recordID,
                      let project = projectIdEntityMap[projectId] else {
                    return
                }
                entity.project = project
            }

        Self.projectStore.projects = projectRecords
            .compactMap { $0.id }
            .compactMap { projectIdEntityMap[$0] }
    }

    private func printLog(_ item: Any) {
        if let error = item as? Error {
            print("🚨 \(error)")
        } else {
            print("✅ \(item)")
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
