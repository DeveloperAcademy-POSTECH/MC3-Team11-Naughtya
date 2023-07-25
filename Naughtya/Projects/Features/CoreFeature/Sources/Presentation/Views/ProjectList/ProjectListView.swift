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
                            .contextMenu {
                                Button {
                                    self.showModal = true
                                } label: {
                                    Label("Modify", systemImage: "pencil")
                                        .labelStyle(.titleAndIcon)
                                }

                                Button {
                                    Task {
                                        try Self.projectUseCase.toggleIsBookmarked(
                                            project.entity,
                                            isBookmarked: !project.isBookmarked)
                                    }
                                } label: {
                                    Label("Bookmark", systemImage: "bookmark")
                                        .labelStyle(.titleAndIcon)
                                }

                                Divider()
                                Button(role: .destructive) {
                                    Task {
                                        try Self.projectUseCase.delete(project.entity)
                                    }
                                } label: {
                                    Label("삭제", systemImage: "trash")
                                        .labelStyle(.titleAndIcon)
                                }
                            }
                            .sheet(isPresented: self.$showModal) {
                                ProjectSetModalView(project: project)
                            }

                    }
                }
            }

        }
    }
}

struct ListHeaderView: View {
    @State private var showModal = false
    var body: some View {
        HStack {
            Text("All My Projects")
                .font(.largeTitle)
                .foregroundColor(.black)
            Spacer()
            Button {
                self.showModal = true
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 15, height: 15)
            }
            .buttonStyle(.borderless)
            .sheet(isPresented: self.$showModal) {
                ProjectSetModalView()
            }
            .tint(.black)
        }
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
    }
}
