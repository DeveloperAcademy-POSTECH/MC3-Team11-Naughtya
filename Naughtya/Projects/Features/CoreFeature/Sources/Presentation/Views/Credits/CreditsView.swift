//
//  CreditsView.swift
//  CoreFeature
//
//  Created by byo on 2023/08/01.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI
import Combine

final class CreditsViewModel: ObservableObject {
    @Published var rootViewHeight: Int = 0
    @Published var todoListViewHeight: Int = 0
    @Published var offsetY: Int = 0
    @Published var offsetReadOnly: CGPoint = .zero
    @Published var isManualScrolling: Bool = false

    deinit {
        print("@LOG ah deinit")
    }

    func setupAutoScrolling() {
        Timer.scheduledTimer(withTimeInterval: 0.005, repeats: true) { [weak self] _ in
            guard let `self` = self else {
                return
            }
            guard offsetY <= Int(todoListViewHeight - rootViewHeight) else {
                return
            }
            offsetY += 1
        }
    }
}

public struct CreditsView: View {
    let projectResult: ProjectResultModel
    @StateObject private var viewModel = CreditsViewModel()

    public init(projectResult: ProjectResultModel) {
        self.projectResult = projectResult
    }

    public var body: some View {
        GeometryReader { rootGeometry in
            ScrollViewReader { _ in
                OffsetObservingScrollView(offset: $viewModel.offsetReadOnly) {
                    ZStack(alignment: .top) {
                        VStack(spacing: 0) {
                            ForEach(0 ..< viewModel.todoListViewHeight) { id in
                                Color.clear
                                    .frame(height: 1)
                                    .id(id)
                            }
                        }
                        todoListView
                            .padding(.top, CGFloat(rootGeometry.size.height))
                            .background(
                                GeometryReader { todoListGeometry in
                                    ZStack(alignment: .bottom) {
                                        backgroundView
                                            .overlay(alignment: .top) {
                                                buildObjectsView(width: rootGeometry.size.width)
                                                    .offset(y: (-CGFloat(viewModel.offsetY) + viewModel.offsetReadOnly.y / 2) / -2)
                                            }
                                            .onAppear {
                                                viewModel.todoListViewHeight = Int(todoListGeometry.size.height)
                                            }
                                        bottomObjectView
                                    }
                                }
                            )
                    }
                    .offset(y: -CGFloat(viewModel.offsetY) + viewModel.offsetReadOnly.y * 2)
                }
                .frame(
                    width: rootGeometry.size.width,
                    height: rootGeometry.size.height
                )
            }
            .onAppear {
                viewModel.rootViewHeight = Int(rootGeometry.size.height)
                viewModel.setupAutoScrolling()
            }
        }
    }

    private var todoListView: some View {
        VStack(spacing: 100) {
            VStack(spacing: 26) {
                Text(projectResult.projectName)
                    .font(.system(size: 80, weight: .bold))
                VStack(spacing: 5) {
                    Text("2023.01.01 ~ 2024.01.01")
                        .fontWeight(.medium)
                    if let goals = projectResult.project.goals {
                        Text("\(goals) 위해서")
                            .fontWeight(.semibold)
                    }
                }
                .font(.system(size: 20))
            }
            HStack {
                Spacer()
                CreditsTodoListView(projectResult: projectResult)
                Spacer()
            }
        }
        .padding(.bottom, 200)
    }

    private var backgroundView: some View {
        LinearGradient(
            colors: [
                .red,
                .blue
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var bottomObjectView: some View {
        Circle()
            .frame(
                width: 800,
                height: 400
            )
            .offset(y: 200)
    }

    private func buildObjectsView(width: CGFloat) -> some View {
        let spacing: CGFloat = 200
        let count = Int(width / spacing)
        return VStack(spacing: spacing) {
            ForEach(0 ..< count) { _ in
                CreditsObjectView(offsetX: .random(in: -width / 2 ... width / 2))
            }
        }
    }
}
