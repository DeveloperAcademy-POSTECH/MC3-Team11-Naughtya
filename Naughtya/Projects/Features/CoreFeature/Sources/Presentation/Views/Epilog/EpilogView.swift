//
//  EpilogView.swift
//  CoreFeature
//
//  Created by byo on 2023/08/01.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI
import Combine

public struct EpilogView: View {
    let projectResult: ProjectResultModel
    @StateObject private var viewModel = EpilogViewModel()

    public init(projectResult: ProjectResultModel) {
        self.projectResult = projectResult
    }

    public var body: some View {
        GeometryReader { rootGeometry in
            ZStack {
                backgroundView
                OffsetObservingScrollView(offset: $viewModel.offsetReadOnly) {
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
                        .background(alignment: .bottom) {
                            bottomView
                                .frame(
                                    width: rootGeometry.size.width,
                                    height: rootGeometry.size.height
                                )
                        }
                        .offset(y: -CGFloat(viewModel.offsetY) + viewModel.offsetReadOnly.y * 2)
                }
                .background(alignment: .top) {
                    objectsView
                        .padding(.top, CGFloat(rootGeometry.size.height))
                        .offset(y: (-CGFloat(viewModel.offsetY) + viewModel.offsetReadOnly.y * 2) / 2)
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
                    .foregroundColor(.white)
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
                .foregroundColor(.customGray2)
                .font(.system(size: 39))
            }
            HStack {
                    Spacer()
                    EpilogTodoListView(projectResult: projectResult)
                    Spacer()
            }
        }
    }

    private var objectsView: some View {
        VStack {
            if viewModel.rootViewHeight > 0 {
                ForEach(0 ..< 10) { index in
                    let model = EpilogObjectModel(
                        imageName: "credits_object_\(index % 4)",
                        isLeading: index % 2 == 0
                    )
                    EpilogObjectView(model: model)
                }
            }
        }
    }

    private var bottomView: some View {
        ZStack {
            MacOSCoreFeatureAsset.logo.swiftUIImage
                .scaleEffect(x: 0.8, y: 0.8)
        }
    }

    private var backgroundView: some View {
        LinearGradient(
            colors: [
                .black,
                Color(red: 36 / 255, green: 37 / 255, blue: 39 / 255)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
