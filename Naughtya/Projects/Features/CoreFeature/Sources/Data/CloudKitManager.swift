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
    public static let shared = CloudKitManager()

    private let container = CKContainer(identifier: "iCloud.Naughtya.TodoList")

    private init() {
    }

    private var database: CKDatabase {
        container.database(with: .private)
    }

    @discardableResult
    func create<T: Recordable>(_ record: T) async throws -> T {
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

    func readList<T: Recordable>(
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

    func readItem<T: Recordable>(
        _ recordType: T.Type,
        id: CKRecord.ID
    ) async throws -> T {
        let ckRecord = try await database.record(for: id)
        let record = T.build(ckRecord: ckRecord)
        return record
    }

    func update<T: Recordable>(_ record: T) async throws {
        guard let id = record.id else {
            return
        }
        let ckRecord = try await database.record(for: id)
        ckRecord.setValuesForKeys(record.dictionary)
        try await database.save(ckRecord)
    }

    func delete(_ id: CKRecord.ID?) async throws {
        guard let id = id else {
            return
        }
        try await database.deleteRecord(withID: id)
    }

    private func printLog(_ item: Any) {
        if let error = item as? Error {
            print("🚨 \(error)")
        } else {
            print("✅ \(item)")
        }
    }
}
