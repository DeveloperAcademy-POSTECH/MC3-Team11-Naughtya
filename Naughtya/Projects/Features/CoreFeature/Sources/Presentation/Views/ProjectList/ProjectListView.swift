//
//  ProjectListView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ProjectListView: View {
    private static let projectUseCase: ProjectUseCase = DefaultProjectUseCase()
    private static let dummyDataGenerator: DummyDataGenerator = .shared
    private static let schedulingStore: SchedulingStore = .shared

    public let projects: [ProjectModel]
    public let projectSelector: ProjectSelectable?
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
            VStack(spacing: 15) {
                headerView
                if projects.isEmpty {
                    emptyView
                } else {
                    ScrollView {
                        ForEach(projects) { project in
                            VStack {
                                if let projectSelector = projectSelector {
                                    ProjectCardView(
                                        project: project,
                                        projectSelector: projectSelector
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
                }
                Spacer()
            }
            .padding(.horizontal, 10)
            addButton
        }
    }

    private var headerView: some View {
        HStack {
            Text("All My Projects")
                .font(.system(size: 14).weight(.medium))
                .foregroundColor(Color.customGray4)
            Spacer()
            Button {
                Self.dummyDataGenerator.generate()
            } label: {
                Text("dummy")
            }
            Button {
                Self.schedulingStore.managers
                    .forEach {
                        $0.tasksBatch.batchTasks()
                    }
            } label: {
                Text("result")
            }
        }
        .padding(.horizontal, 5)
        .padding(.top, 10)
    }

    private var emptyView: some View {
        HStack {
            Spacer()
            Text("프로젝트가 없어요.")
                .multilineTextAlignment(.center)
                .font(.system(size: 16))
                .foregroundColor(.customGray3)
            Spacer()
        }
        .frame(height: 68)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.customGray5)
        )
    }

    private var addButton: some View {
        VStack(alignment: .center) {
            Spacer()
            Button {
                showModal = true
            } label: {
                Circle()
                    .frame(width: 44, height: 44)
                    .overlay {
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    }
            }
            .buttonStyle(.borderless)
            .tint(.pointColor)
            .padding(.bottom, 50)
            .sheet(isPresented: self.$showModal) {
                ProjectSetModalView()
            }
        }
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
    }
}
