//
//  ResultNameView.swift
//  CoreFeature
//
//  Created by DongHyeok Kim on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI
public struct ResultNameView: View {
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
                Text("\(projectResult.projectName) 프로젝트")
                    .lineLimit(1)
                    .font(
                        Font.custom("Apple SD Gothic Neo", size: 32 * (geometry.size.width/1512))
                            .weight(.bold)
                    )
                    .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))

                Text("\(projectResult.daysInProject)일간의 능력로그") // 종료된 프로젝트와 데이터 연결
                    .lineLimit(1)
                    .font(
                        Font.custom("Apple SD Gothic Neo", size: 28 * (geometry.size.width/1512))
                            .weight(.medium)
                    )
                    .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                    .padding(.vertical, 10)

            }

//            Spacer(minLength: 600)
            Spacer()

            VStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 79, height: 79)
                    .background(
                        MacOSCoreFeatureAsset.circle.swiftUIImage // 이미지 변경
                            .resizable()
                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 79, height: 79)
                            .clipped()
                    )
                    .padding(.bottom, 10 * (geometry.size.height/892))

                Text("에필로그")
                    .font(
                        Font.custom("Apple SD Gothic Neo", size: 16.17978 * (geometry.size.height/892))
                            .weight(.semibold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
        }

    }
}

// struct ResultNameView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultNameView(projectResult: .from(entity: ProjectResultEntity.sample))
//    }
// }
