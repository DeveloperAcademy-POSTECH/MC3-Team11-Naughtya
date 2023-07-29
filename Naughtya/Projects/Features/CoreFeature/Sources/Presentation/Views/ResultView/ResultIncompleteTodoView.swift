//
//  ResultIncompleteTodoView.swift
//  CoreFeature
//
//  Created by DongHyeok Kim on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ResultIncompleteTodoView: View {
    public init() {
        // Initialization code here
    }
    public var body: some View {
        VStack(spacing: 27) {
            Text(" 미완료 To-Do ")
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 24)
                        .weight(.bold)
                )
                .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
            VStack {

                    Text("플러터 개발 일지 쓰기 은/는 미완료 했지만")
                      .font(
                        Font.custom("Apple SD Gothic Neo", size: 18)
                          .weight(.semibold)
                      )
                      .foregroundColor(Color(red: 0.97, green: 0.97, blue: 0.97))

                Text("다음번에 성공한다면 플러터 개발 능력을 획득 할 수 있어요!")
                  .font(Font.custom("Apple SD Gothic Neo", size: 16))
                  .foregroundColor(Color(red: 0.86, green: 0.86, blue: 0.86))

                }

            }
    }
}

struct ResultIncompleteTodoView_Previews: PreviewProvider {
    static var previews: some View {
        ResultIncompleteTodoView()
    }
}
