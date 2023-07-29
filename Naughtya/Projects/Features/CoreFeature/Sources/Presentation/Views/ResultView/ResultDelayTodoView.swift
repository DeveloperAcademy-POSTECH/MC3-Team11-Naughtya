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
        VStack(spacing: 27) {
            Text(" Top3 미룬 To-Do ")
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 24)
                        .weight(.bold)
                )
                .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
            VStack {
                HStack { VStack(alignment: .center, spacing: 10) {
                    Text("1")
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 13.83245)
                                .weight(.semibold)
                        )

                    .foregroundColor(Color(red: 0.77, green: 0.77, blue: 0.77)
                    )

                }
                .background(Color(red: 0.27, green: 0.27, blue: 0.27))
                    .cornerRadius(5)

                    Text("플러터 개발 일지 쓰기")
                      .font(
                        Font.custom("Apple SD Gothic Neo", size: 18)
                          .weight(.semibold)
                      )
                      .foregroundColor(Color(red: 0.97, green: 0.97, blue: 0.97))
                    Text("총 3회")
                      .font(
                        Font.custom("Apple SD Gothic Neo", size: 18)
                          .weight(.semibold)
                      )
                      .foregroundColor(Color(red: 0.52, green: 0.52, blue: 0.52))

                }
                Text("미뤘지만, 프로젝트의 성공을 위해 결국 플러터 개발능력 강화 되었어요!")
                  .font(Font.custom("Apple SD Gothic Neo", size: 16))
                  .foregroundColor(Color(red: 0.86, green: 0.86, blue: 0.86))

            }
            .background(Color(red: 0.17, green: 0.17, blue: 0.17))
            .cornerRadius(8)
        }
    }
}

struct ResultDelayTodoView_Previews: PreviewProvider {
    static var previews: some View {
        ResultDelayTodoView()
    }
}
