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
            ZStack {
                backgroundView
                OffsetObservingScrollView(offset: $viewModel.offsetReadOnly) {
                    ZStack(alignment: .top) {
                        VStack(spacing: 0) {
                            ForEach(0 ..< viewModel.todoListViewHeight) { id in
                                Color.clear
                                    .frame(height: 1)
                                    .id(id)
                            }
                        }
                        objectsView
                            .offset(y: -CGFloat(viewModel.offsetY / 2) + viewModel.offsetReadOnly.y * 2)
                        todoListView
                            .padding(.vertical, CGFloat(rootGeometry.size.height))
                            .background(
                                GeometryReader { todoListGeometry in
                                    Color.clear
                                        .onAppear {
                                            viewModel.todoListViewHeight = Int(todoListGeometry.size.height)
                                        }
                                }
                            )
                            .overlay(alignment: .bottom) {
                                bottomObjectView
                            }
                            .offset(y: -CGFloat(viewModel.offsetY) + viewModel.offsetReadOnly.y * 2)
                    }
                }
            }
            .frame(
                width: rootGeometry.size.width,
                height: rootGeometry.size.height
            )
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
                    .font(.system(size: 173, weight: .bold))
                    .frame(height: 208)
                VStack(spacing: 5) {
                    if let startedAt = projectResult.project.startedAt?.getDateString("yyyy.MM.dd"),
                       let endedAt = projectResult.project.endedAt?.getDateString("yyyy.MM.dd") {
                        Text("\(startedAt) ~ \(endedAt)")
                            .fontWeight(.medium)
                            .frame(height: 65)
                    }
                    if let goals = projectResult.project.goals {
                        Text("\(goals) 위해서")
                            .fontWeight(.semibold)
                            .frame(height: 65)
                    }
                }
                .font(.system(size: 39))
            }
            HStack {
                Spacer()
                CreditsTodoListView(projectResult: projectResult)
                Spacer()
            }
        }
    }

    private var objectsView: some View {
        VStack {
            ForEach(0 ..< 10) { index in
                let model = CreditsObjectModel(
                    imageName: "credits_object_\(index % 4)",
                    isLeading: index % 2 == 0
                )
                CreditsObjectView(model: model)
            }
        }
    }

    private var bottomObjectView: some View {
        let model = CreditsObjectModel(
            imageName: "credits_last_object",
            isLeading: true
        )
        return CreditsObjectView(model: model)
    }

    private var backgroundView: some View {
        LinearGradient(
            colors: [
                Color(red: 36 / 255, green: 37 / 255, blue: 39 / 255),
                .black
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
