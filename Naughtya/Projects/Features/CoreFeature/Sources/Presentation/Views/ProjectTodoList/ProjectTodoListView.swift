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
        VStack(spacing: 0) {
            if projects.isEmpty {
                Spacer()
                    .frame(height: 250)
                MacOSCoreFeatureAsset.projecttodolistempty.swiftUIImage
                    .resizable()
                    .frame(maxWidth: 539)
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.3)
            } else {
                ForEach(projects) { project in
                    ProjectItemView(project: project)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct ProjectTodoListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectTodoListView()
    }
}
