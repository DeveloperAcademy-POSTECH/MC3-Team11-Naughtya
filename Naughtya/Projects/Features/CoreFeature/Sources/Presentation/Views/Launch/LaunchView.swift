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
    @StateObject private var viewModel = LaunchViewModel()

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        ZStack {
            if viewModel.isLoaded {
                content()
            } else {
                Text("Loading")
            }
        }
    }
}
