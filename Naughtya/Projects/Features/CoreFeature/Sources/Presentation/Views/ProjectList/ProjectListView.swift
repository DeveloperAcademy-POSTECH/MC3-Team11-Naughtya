//
//  pr.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ProjectListView: View {
    private static let projectUseCase: ProjectUseCase = MockProjectUseCase()
    public let projects: [ProjectModel]

    public init(projects: [ProjectModel] = []) {
        self.projects = projects.sorted { $0.isBookmarked && !$1.isBookmarked }
    }

    @State private var showModal = false

    public var body: some View {
        VStack(spacing: 16) {
            List {
                Section(header: ListHeaderView()) {
                    ForEach(projects) { project in
                        ProjectCardView(project: project)
                    }
                }
            }
            .listStyle(.plain)
            Spacer()
            Button {
                self.showModal = true
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 15, height: 15)
            }
            .buttonStyle(.borderless)
        }
        .sheet(isPresented: self.$showModal) {
            ProjectSetModalView()
        }
        .onAppear { // MARK: - 테스트 후 삭제(가짜데이터)
            Task {
                try await Self.projectUseCase.create(
                    category: "MC3",
                    goals: "mc2",
                    startedAt: Date(),
                    endedAt: Date()
                )
            }
        }
    }
}

struct ListHeaderView: View {
    @State private var showModal = false
    var body: some View {
        HStack {
            Text("All My Projects")
                .font(.title)
                .foregroundColor(.black)
        }
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
    }
}