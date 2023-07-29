//
//  ResultView.swift
//  CoreFeature
//
//  Created by DongHyeok Kim on 2023/07/29.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct ResultView: View {
    public init() {
        // Initialization code here
    }
    public var body: some View {
        VStack(spacing: 0) {
            ResultNameView()
            ResultCompleteTodoView()
            ResultCardView()
            HStack(alignment: .center, spacing: 80) {
                ResultDelayTodoView()

                ResultIncompleteTodoView()
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 30)
        }
        .padding(.leading, 50)
        .padding(.bottom, 95)
        .frame(minWidth: 816, maxWidth: 1512, minHeight: 729, maxHeight: 929, alignment: .topLeading)
        .background(Color(red: 0.13, green: 0.13, blue: 0.13))
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
    }
}
