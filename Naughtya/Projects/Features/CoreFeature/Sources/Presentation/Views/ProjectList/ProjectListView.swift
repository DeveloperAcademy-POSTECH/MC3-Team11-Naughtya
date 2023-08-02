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
            VStack(spacing: 15) {
                ProjectListHeaderView()
                if projects.isEmpty {
                    ProjectListEmptyView()
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(projects) { project in
                                ProjectCardView(project: project)
                            }
                            Spacer()
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 10)
            addButton
        }
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
                            .font(.appleSDGothicNeo(size: 24))
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
