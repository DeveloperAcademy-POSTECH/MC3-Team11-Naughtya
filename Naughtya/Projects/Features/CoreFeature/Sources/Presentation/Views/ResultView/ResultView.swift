//
//  ResultView.swift
//  CoreFeature
//
//  Created by DongHyeok Kim on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ResultView: View {
    public let projectResult: ProjectResultModel

    public init(projectResult: ProjectResultModel) {
        self.projectResult = projectResult
    }

    public var body: some View {
        ZStack {
            if projectResult.isGenerated {
                VStack(spacing: 0) {
                    ResultNameView(projectResult: projectResult)
                    ResultCompleteTodoView(projectResult: projectResult)
                    ResultCardView(projectResult: projectResult)
                    HStack(alignment: .center, spacing: 80) {
                        ResultDelayTodoView(projectResult: projectResult)
                        ResultIncompleteTodoView(projectResult: projectResult)
                    }
                    .padding(.vertical, 30)
                    .padding(.horizontal, 30)
                }
                .padding(.leading, 50)
                .padding(.bottom, 95)
                .background(Color(red: 0.13, green: 0.13, blue: 0.13))
            } else {
                emptyView
            }
        }
        .frame(minWidth: 816, maxWidth: 1512, minHeight: 729, maxHeight: 929, alignment: .topLeading)
    }

    private var emptyView: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("리포트 생성중 🙂")
                    .font(.largeTitle)
                Spacer()
            }
            Spacer()
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(projectResult: .from(entity: ProjectResultEntity.sample))
    }
}
