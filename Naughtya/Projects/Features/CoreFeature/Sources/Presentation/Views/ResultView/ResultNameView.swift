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
    let selectedNum: Int

    public init(geometry: GeometryProxy, selectedNum: Int) {
        self.geometry = geometry
        self.selectedNum = selectedNum
    }
    public var body: some View {
        switch selectedNum {
        case 1:
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("MC3 프로젝트")
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 32 * (geometry.size.width/1512)) // 화면 비율에 따라 글자 크기 조정
                        )
                        .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
                    Text("35일간의 여정")
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 28 * (geometry.size.width/1512)) // 화면 비율에 따라 글자 크기 조정
                        )
                        .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                        .padding(.vertical, 10) // 화면 비율에 따라 padding 조정
                }

                Spacer()
                VStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 79 * (geometry.size.width/1512), height: 78 * (geometry.size.height/892))
                        .background(
                            Image(systemName: "leaf") // 이미지 변경
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 79 * (geometry.size.width/1512), height: 78 * (geometry.size.height/892))
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
                .background(Color(red: 0.13, green: 0.13, blue: 0.13))
            }
        case 2:
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("MC3 프로젝트")
                        .font(
                            .system( size: 32 * (geometry.size.width/1512)) // 화면 비율에 따라 글자 크기 조정
                        )
                        .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
                    Text("35일간의 여정")
                        .font(
                            .system( size: 28 * (geometry.size.width/1512)) // 화면 비율에 따라 글자 크기 조정
                        )
                        .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                        .padding(.vertical, 10) // 화면 비율에 따라 padding 조정
                }
                Spacer()
            }
            .padding(.top, 35 * geometry.size.height / 892)
            .padding(.leading, 30)
        default:
            Text("DQ")

        }
    }
}
