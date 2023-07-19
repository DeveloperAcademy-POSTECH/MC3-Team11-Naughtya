//
//  ProjectListView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/18.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ProjectListView: View {
    public let projects: [ProjectModel]

    public init(projects: [ProjectModel] = []) {
        self.projects = projects
    }

    @State private var showModal = false

    public var body: some View {
        VStack {
            VStack(spacing: 16) {
                ForEach(projects) { project in
                    HStack {
                        Text(project.category.uppercased())
                            .font(.title.weight(.black))
                        Spacer()
                        Text("\(project.completedTodos.count)/\(project.todos.count)")
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
            }
        }
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
    }
}
