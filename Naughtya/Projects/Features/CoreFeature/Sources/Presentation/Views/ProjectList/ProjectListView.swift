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
    @State private var showModal = false

    public init(projects: [ProjectModel] = []) {
        self.projects = projects
    }

    public var body: some View {
        ZStack {
            Color.customGray8
            VStack(spacing: 15) {
                headerView
                if projects.isEmpty {
                    emptyView
                } else {
                    ScrollView {
                        ForEach(projects) { project in
                            ProjectCardView(project: project)
                                .frame(width: 278, height: 68)
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
                .font(Font.custom("SF Pro", size: 14).weight(.medium))
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
            Text("프로젝트가 없습니다.")
                .multilineTextAlignment(.center)
                .font(Font.custom("SF Pro", size: 12).weight(.semibold))
                .foregroundColor(.customGray2)
            Spacer()
        }
        .frame(height: 68)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.customGray4, lineWidth: 1)
        )
    }

    private var addButton: some View {
        VStack(alignment: .center) {
            Spacer()
            Button {
                showModal = true
            } label: {
                HStack(alignment: .center, spacing: 5) {
                    Spacer()
                    Text("+")
                        .font(Font.custom("SF Pro", size: 20))
                    Text("Add project")
                        .font(Font.custom("SF Pro", size: 14).weight(.semibold))
                    Spacer()
                }
                .frame(height: 36)
                .lineLimit(1)
                .foregroundColor(.white)
                .background(Color.pointColor)
                .cornerRadius(10)
            }
            .buttonStyle(.borderless)
            .frame(
                minWidth: 100,
                maxWidth: .infinity,
                alignment: .center
            )
            .padding(.horizontal, 81)
            .padding(.bottom, 103)
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
