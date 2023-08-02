//
//  ProjectResultCardView.swift
//  CoreFeature
//
//  Created by byo on 2023/08/02.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

struct ProjectResultCardView: View {
    let projectResult: ProjectResultModel
    let isSelected: Bool

    var body: some View {
        VStack {
            HStack {
                Text(projectResult.projectName)
                    .lineLimit(1)
                    .font(.appleSDGothicNeo(size: 24, weight: .bold))
                Spacer()
                if let endedAt = projectResult.project.endedAt?.getDateString("yyyy.MM.dd") {
                    Text("-\(endedAt)")
                        .lineLimit(1)
                        .font(.appleSDGothicNeo(size: 14, weight: .semibold))
                }
            }
            .offset(y: 2)
        }
        .padding(.leading, 25)
        .padding(.trailing, 20)
        .frame(height: 68)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(isSelected ? Color.customGray5 : Color.customGray7)
        )
        .animation(.easeOut, value: isSelected)
    }
}

struct ProjectResultCardView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectResultCardView(
            projectResult: .from(entity: .sample),
            isSelected: false
        )
    }
}
