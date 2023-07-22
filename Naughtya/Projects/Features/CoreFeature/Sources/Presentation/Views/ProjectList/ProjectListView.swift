//
//  ProjectListView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ProjectListView: View {
    private static let dummyDataGenerator: DummyDataGenerator = .shared

    public let projects: [ProjectModel]

    public init(projects: [ProjectModel] = []) {
        self.projects = projects
    }

    @State private var showModal = false

    public var body: some View {
        VStack {
            VStack(spacing: 16) {
                ForEach(projects) { project in
                    VStack {
                        HStack {
                            Text(project.category.uppercased())
                                .font(.title.weight(.black))
                            Spacer()
                            Text("\(project.completedTodosCount)/\(project.totalTodosCount)")
                        }
                        if let startedAt = project.startedAt,
                           let endedAt = project.endedAt {
                            Text("\(startedAt.getDateString())~\(endedAt.getDateString())")
                        }
                    }
                }
            }
            HStack(alignment: .bottom) {
                Button("새 프로젝트 생성") {
                    self.showModal = true
                }
                .sheet(isPresented: self.$showModal) {
                    ProjectSetModalView()
                }
                Button("더미 프로젝트 생성") {
                    Self.dummyDataGenerator.generate()
                }
            }
        }
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
    }
}
