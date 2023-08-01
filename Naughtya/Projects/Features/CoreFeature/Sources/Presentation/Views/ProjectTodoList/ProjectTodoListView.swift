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
        VStack {
            if projects.isEmpty {
                Spacer().frame(height: 150)
                MacOSCoreFeatureAsset.projecttodolistempty.swiftUIImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.3)
            } else {
                ForEach(projects) { project in
                    ProjectItemView(project: project)
                }
            }
            Spacer()
        }
        .padding(0)
    }
}

struct ProjectTodoListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectTodoListView()
    }
}
