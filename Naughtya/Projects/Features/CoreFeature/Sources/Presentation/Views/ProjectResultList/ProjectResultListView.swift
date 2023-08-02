//
//  ProjectResultListView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/24.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ProjectResultListView: View {
    private static let projectResultUseCase: ProjectResultUseCase = DefaultProjectResultUseCase()

    public let projectResults: [ProjectResultModel]
    public let selectedProjectResult: ProjectResultModel?
    public let projectResultSelector: ProjectResultSelectable

    public init(
        projectResults: [ProjectResultModel] = [],
        selectedProjectResult: ProjectResultModel? = nil,
        projectResultSelector: ProjectResultSelectable
    ) {
        self.projectResults = projectResults
        self.selectedProjectResult = selectedProjectResult
        self.projectResultSelector = projectResultSelector
    }

    public var body: some View {
        ZStack {
            VStack(spacing: 15) {
                ProjectListHeaderView()
                if projectResults.isEmpty {
                    ProjectListEmptyView()
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(projectResults) { projectResult in
                                ProjectResultCardView(
                                    projectResult: projectResult,
                                    isSelected: projectResult.entity === selectedProjectResult?.entity
                                )
                                .onTapGesture {
                                    projectResultSelector.selectProjectResult(projectResult)
                                }
                            }
                            Spacer()
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 10)
        }
    }
}
