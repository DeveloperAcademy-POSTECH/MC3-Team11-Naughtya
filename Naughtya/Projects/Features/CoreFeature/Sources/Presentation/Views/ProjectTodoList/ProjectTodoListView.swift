//
//  ProjectTodoListView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ProjectTodoListView: View {
    public let projects: [ProjectModel]

    public init(projects: [ProjectModel] = []) {
        self.projects = projects
    }

    public var body: some View {
        VStack(spacing: 16) {
                ForEach(projects.filter { $0.isSelected }) { project in
                    ProjectItemView(project: project)
                }
        }
    }
}

struct ProjectTodoListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectTodoListView()
    }
}
