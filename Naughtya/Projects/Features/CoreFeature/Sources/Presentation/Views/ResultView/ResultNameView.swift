//
//  ResultNameView.swift
//  CoreFeature
//
//  Created by DongHyeok Kim on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI
public struct ResultNameView: View {
    let geometry: GeometryProxy

    public init(geometry: GeometryProxy) {
        self.geometry = geometry
    }
    public var body: some View {

            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("MC3 프로젝트")
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 32 * (geometry.size.width/1512)) // 화면 비율에 따라 글자 크기 조정
                        )
                        .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
                    Text("35일간의 여정")
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 20 * (geometry.size.width/1512)) // 화면 비율에 따라 글자 크기 조정
                        )
                        .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                        .padding(.vertical, 10) // 화면 비율에 따라 padding 조정
                }

                Spacer()
                VStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 79, height: 78)
                        .background(
                            Image(systemName: "leaf") // 이미지 변경
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 79 * (geometry.size.width/1512), height: 78 * (geometry.size.width/1512))
                                .clipped()
                        )
                        .padding(.bottom, 15)

                    Text("타임라인 돌아보기")
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 16.17978 * (geometry.size.width/1512))
                                .weight(.semibold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
                .padding(.trailing, 30)
                .background(Color(red: 0.13, green: 0.13, blue: 0.13))
            }
            }
//            .padding(.top, 20)
//            .padding(.bottom, 10)
//            .frame(minWidth: 762, maxWidth: 1389, minHeight: 99, maxHeight: 112)

}
