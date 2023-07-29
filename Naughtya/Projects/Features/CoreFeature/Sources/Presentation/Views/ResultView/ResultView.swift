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
        VStack {
            ResultNameView()
            ResultCompleteTodoView()
            ResultCardView()
            HStack {
                ResultDelayTodoView()
                ResultIncompleteTodoView()
            }
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
    }
}
