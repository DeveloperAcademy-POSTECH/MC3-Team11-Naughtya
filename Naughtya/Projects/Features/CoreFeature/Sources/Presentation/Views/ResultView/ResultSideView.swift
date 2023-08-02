//
//  ProjectListView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ResultSideView: View {
    private static let projectUseCase: ProjectUseCase = DefaultProjectUseCase()
    public let projects: [ProjectModel]
    public let projectSelector: ProjectSelectable?
    @State private var selectedProjectIndex: Int = 0
    @State private var showModal = false

    public init(
        projects: [ProjectModel] = [],
        projectSelector: ProjectSelectable? = nil
    ) {
        self.projects = projects
        self.projectSelector = projectSelector
    }

    public var body: some View {
        ZStack {
            Color.customGray7
            VStack(spacing: 15) {
                headerView
                    ScrollView {
                        ForEach(Array(projects.enumerated()), id: \.offset) { _, project in
                            VStack {
                                if let projectSelector = projectSelector {
                                    ProjectCardView(
                                        project: project
//                                        isSelected: index == selectedProjectIndex
                                    )
                                } else {
                                    ProjectCardView(
                                        project: project,
                                        dragDropDelegate: DragDropManager.shared
                                    )
                                }
                            }
                            .frame(height: 68)
                        }
                        Spacer()
                    }

                Spacer()
            }
            .padding(.horizontal, 10)

        }
    }

    private var headerView: some View {
        HStack {
            Text("All My Projects")
                .font(.system(size: 14))
                .fontWeight(.medium)
                .foregroundColor(Color.customGray4)
            Spacer()
        }
        .padding(.horizontal, 5)
        .padding(.top, 10)
    }

}

struct ResultSideView_Previews: PreviewProvider {
    static var previews: some View {
        ResultSideView()
    }
}
