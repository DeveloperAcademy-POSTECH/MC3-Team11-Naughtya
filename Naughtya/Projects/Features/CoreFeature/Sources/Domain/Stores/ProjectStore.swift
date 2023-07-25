//
//  ProjectStore.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public final class ProjectStore: ObservableObject {
    public static let shared: ProjectStore = .init()
    private static let cloudKitManager: CloudKitManager = .shared
    
    @Published public var projects: [ProjectEntity] = []
    
    private init() {
        fetchDataFromCloudKit()
    }
    
    public func update() {
        objectWillChange.send()
    }
    
    private func fetchDataFromCloudKit() {
        Task {
            self.projects = try await Self.cloudKitManager.readList(ProjectRecord.self)
                .map { $0.entity }
        }
    }
}
