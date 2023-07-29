//
//  ResultDelayTodoView.swift
//  CoreFeature
//
//  Created by DongHyeok Kim on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ResultDelayTodoView: View {
    public init() {
        // Initialization code here
    }
    public var body: some View {
        VStack(alignment: .leading, spacing: 27) {
            Text("Top3 미룬 To-DO")
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 24)
                        .weight(.bold)
                )
                .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
            VStack(alignment: .leading, spacing: 23) {

                HStack {
                    VStack {
                        Text("1")
                          .font(
                            Font.custom("Apple SD Gothic Neo", size: 13.83245)
                              .weight(.semibold)
                          )

                          .foregroundColor(Color(red: 0.77, green: 0.77, blue: 0.77))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(red: 0.27, green: 0.27, blue: 0.27))
                    .cornerRadius(5)

                    Text("플러터 개발 일지 쓰기")
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 18)
                                .weight(.semibold)
                        )
                        .foregroundColor(Color(red: 0.97, green: 0.97, blue: 0.97))
                    Spacer()

                    Text("총 3회")
                      .font(
                        Font.custom("Apple SD Gothic Neo", size: 18)
                          .weight(.semibold)
                      )
                      .foregroundColor(Color(red: 0.52, green: 0.52, blue: 0.52))
                }

                Text("다음번에 성공한다면 플러터 개발 능력을 획득 할 수 있어요!")
                    .font(Font.custom("Apple SD Gothic Neo", size: 16))
                    .foregroundColor(Color(red: 0.86, green: 0.86, blue: 0.86))

            }
            .padding(.leading, 50)
            .padding(.trailing, 102)
            .padding(.vertical, 36)
            .background(Color(red: 0.17, green: 0.17, blue: 0.17))
            .cornerRadius(8)
            .frame(maxWidth: 540)

        }
    }
}

struct ResultDelayTodoView_Previews: PreviewProvider {
    static var previews: some View {
        ResultDelayTodoView()
    }
}
