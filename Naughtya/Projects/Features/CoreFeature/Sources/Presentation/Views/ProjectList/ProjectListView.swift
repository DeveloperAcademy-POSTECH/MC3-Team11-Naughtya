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
        self.projects = projects.sorted { $0.isBookmarked && !$1.isBookmarked }
    }

    @State private var showModal = false

    public var body: some View {
        VStack {
            VStack(spacing: 16) {
                ForEach(projects) { project in
                    ProjectCardView(project: project)
                }
            }
            Spacer()
            HStack(alignment: .bottom) {
                Spacer()
                Button("새 프로젝트 생성") {
                    self.showModal = true
                }
                .sheet(isPresented: self.$showModal) {
                    ProjectSetModalView()
                }
                Spacer()
            }
        }
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
    }
}
