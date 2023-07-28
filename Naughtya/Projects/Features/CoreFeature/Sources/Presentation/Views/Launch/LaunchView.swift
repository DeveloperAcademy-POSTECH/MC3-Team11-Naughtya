//
//  LaunchView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/26.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct LaunchView<Content>: View where Content: View {
    private let content: () -> Content
    @State private var isLoaded = false

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        ZStack {
            if isLoaded {
                content()
            } else {
                Text("Loading")
            }
        }
        .onAppear {
            setup()
        }
    }

    private func setup() {
        Task {
            try await CloudKitManager.shared.syncWithStores()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isLoaded = true
        }
    }
}
