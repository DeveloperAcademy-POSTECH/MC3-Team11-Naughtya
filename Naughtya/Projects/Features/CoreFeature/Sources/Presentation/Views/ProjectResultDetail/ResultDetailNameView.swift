//
//  ResultNameView.swift
//  CoreFeature
//
//  Created by DongHyeok Kim on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI
public struct ResultDetailNameView: View {
    public let projectResult: ProjectResultModel
    private let geometry: GeometryProxy

    public init(
        projectResult: ProjectResultModel,
        geometry: GeometryProxy
    ) {
        self.projectResult = projectResult
        self.geometry = geometry
    }

    public var body: some View {

            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(projectResult.projectName) 프로젝트 \(projectResult.abilitiesCount)개의 능력 한 눈에 보기")
                        .lineLimit(1)
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 32 * (geometry.size.height/892))
                                .weight(.bold)
                        )
                        .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))

                    Text("\(projectResult.daysInProject)일간의 능력로그") // 종료된 프로젝트와 데이터 연결
                        .lineLimit(1)
                        .font(
                            .system( size: 28 * (geometry.size.height/892))
                            .weight(.medium)
                        )
                        .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                        .padding(.vertical, 10)

                }

                //            Spacer(minLength: 600)
                Spacer()

            }

            .padding(.horizontal, 6)

    }
}
