//
//  ResultTopView.swift
//  CoreFeature
//
//  Created by 김정현 on 2023/07/27.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ResultTopView: View {

    public let projects: [ProjectModel]

    public init(projects: [ProjectModel] = []) {
        self.projects = projects
    }

    public var body: some View {

        ForEach(projects.filter {$0.isSelected}) { project in
            ResultTopListView(project: project)
        }
    }
}
