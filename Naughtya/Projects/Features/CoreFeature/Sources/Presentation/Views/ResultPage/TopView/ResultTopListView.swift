//
//  ResultTopListView.swift
//  CoreFeature
//
//  Created by 김정현 on 2023/07/27.
//  Copyright © 2023 Naughtya. All rights reserved.

import SwiftUI

public struct ResultTopListView: View {

    public let project: ProjectModel

    public init(project: ProjectModel) {
        self.project = project
    }

    public var body: some View {

        if project.isSelected == true {
            VStack(alignment: .leading, spacing: 10) {
                Text("\(project.category) 프로젝트")
                    .font(
                        Font.custom("Apple SD Gothic Neo", size: 32)
                            .weight(.bold)
                    )
                if let startedAt = project.startedAt,
                   let endedAt = project.endedAt {
                    Text("\(startedAt.getDateString())~\(endedAt.getDateString())")

                }

            }
        }
    }

}
