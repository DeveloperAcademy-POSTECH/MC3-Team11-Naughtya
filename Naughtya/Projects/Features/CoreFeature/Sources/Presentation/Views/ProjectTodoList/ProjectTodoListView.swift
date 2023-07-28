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
                Spacer()
                    .frame(height: 300)
                HStack(alignment: .center) {
                    Spacer()
                    Text("프로젝트를 선택해주세요!")
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 24)
                                .weight(.semibold)
                        )
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(Color.pointColor)
                    Spacer()
                }
            } else {
                VStack(spacing: 16) {
                    ForEach(projects) { project in
                        ProjectItemView(project: project)
                    }
                }
            }
        }
    }
}

struct ProjectTodoListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectTodoListView()
    }
}
