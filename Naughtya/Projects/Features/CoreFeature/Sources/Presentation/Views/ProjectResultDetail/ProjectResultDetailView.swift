//
//  ProjectResultDetailView.swift
//  CoreFeature
//
//  Created by 김정현 on 2023/07/31.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ProjectResultDetailView: View {
    private static let projectResultUseCase: ProjectResultUseCase = DefaultProjectResultUseCase()

    @State private var projectResults: [ProjectResultModel] = []

    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    public let projectResult: ProjectResultModel

    public init(projectResult: ProjectResultModel) {
        self.projectResult = projectResult
    }

    public var body: some View {

        let selectedNum: Int = 2
        GeometryReader { geometry in
            HStack {
                VStack {
                    NavigationStack {
                        NavigationView {

                            VStack {
                                ResultNameView(projectResult: projectResult, geometry: geometry, selectedNum: selectedNum)
                                ScrollView(.vertical) {
                                    LazyVGrid(columns: gridItemLayout, alignment: .leading, spacing: 10) {

                                        ForEach((0...1000), id: \.self) { _ in
                                            ProjectDetailCard(geometry: geometry)

                                        }
                                        .padding(EdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 25))
                                    }
                                }
                            }
                            .frame(minWidth: 800)
                            ProjectDoneList(geometry: geometry)
                                .frame(minWidth: 250)

                        }
                    }
                }

            }
            .background(Color.customGray8)

        }
    }

    private func fetchProjectResults() {
        Task {
            projectResults = try await Self.projectResultUseCase.readList()
                .map { .from(entity: $0) }
        }
    }
}