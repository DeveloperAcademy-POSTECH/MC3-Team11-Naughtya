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
            if projects.isEmpty {
                Spacer().frame(height: 200)
                HStack(alignment: .center) {
                    Spacer().frame(width: 70)
                    Text("아무튼 사진임")
                    // 나중에 이미지 넣기
                    Text("프로젝트를 선택해주세요!")
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 24)
                                .weight(.semibold)
                        )
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(Color.pointColor)
                }
            } else {
                ForEach(projects) { project in
                    ProjectItemView(project: project)
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
