//
//  LaunchViewModel.swift
//  CoreFeature
//
//  Created by byo on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

@MainActor
public final class LaunchViewModel: ObservableObject {
    @Published public private(set) var isLoaded: Bool = false

    public init() {
        setup()
    }

    private func setup() {
        Task {
            try? await CloudKitManager.shared.syncWithLocalStore()
            DispatchQueue.main.async { [unowned self] in
                isLoaded = true
            }
        }
    }
}
