//
//  ProjectResultListView.swift
//  CoreFeature
//
//  Created by 김정현 on 2023/07/27.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ProjectResultSideBarView: View {
    private static let projectUseCase: ProjectUseCase = MockProjectUseCase()
    public let projects: [ProjectModel]
    @State private var showModal = false

    public init(projects: [ProjectModel] = []) {
        self.projects = projects.sorted { $0.isBookmarked && !$1.isBookmarked }
    }

    public var body: some View {
        VStack(spacing: 16) {
            List {
               Section(header: ListResultHeaderView()) {
                    ForEach(projects) { project in
                            ProjectCardView(project: project)
                                .sheet(isPresented: self.$showModal) {
                                    ProjectSetModalView(project: project)
                                }

                        }

                }
            }

        }
    }
}

struct ListResultHeaderView: View {

    private static let dummyDataGenerator: DummyDataGenerator = .shared
    @State private var showModal = false

    var body: some View {
        HStack {
            Text("All My Projects")
            Spacer()

        }
    }
}
