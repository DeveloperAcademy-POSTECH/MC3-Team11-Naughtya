//
//  ResultNameView.swift
//  CoreFeature
//
//  Created by DongHyeok Kim on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ResultNameView: View {
    public init() {
        // Initialization code here
    }
    public var body: some View {

            HStack {
                VStack {
                    Text("MC3 프로젝트") // 종료된 프로젝트와 데이터 연결
                        .frame(width: 360, alignment: .leading)
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 32)
                                .weight(.bold)
                        )
                        .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
                        .padding(.bottom, 10)

                    Text("35일간의 여정") // 종료된 프로젝트와 데이터 연결
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 20)
                                .weight(.medium)
                        )
                        .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                        .frame(width: 360, alignment: .leading)
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
                                .frame(width: 79, height: 78)
                                .clipped()
                        )
                        .padding(.bottom, 15)

                    Text("타임라인 돌아보기")
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 16.17978)
                                .weight(.semibold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical, 35)
            .frame(width: 1214)
            .background(Color(red: 0.13, green: 0.13, blue: 0.13))
    }
}

struct ResultNameView_Previews: PreviewProvider {
    static var previews: some View {
        ResultNameView()
    }
}
