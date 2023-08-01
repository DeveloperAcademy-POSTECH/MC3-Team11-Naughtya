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
//        ZStack {
//            Color.customGray8
            VStack {
                if projects.isEmpty {
                    Spacer(minLength: 300)
                    HStack {
                        Spacer()
                        Text("프로젝트를 선택해주세요!")
                            .font(Font.custom("Apple SD Gothic Neo", size: 24).weight(.semibold))
                            .foregroundColor(.pointColor)
                        Spacer()
                    }
                } else {
                    ForEach(projects) { project in
                        ProjectItemView(project: project)
                    }
                }
            }
            .padding(0)
//        }
    }
}

struct ProjectTodoListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectTodoListView()
    }
}
