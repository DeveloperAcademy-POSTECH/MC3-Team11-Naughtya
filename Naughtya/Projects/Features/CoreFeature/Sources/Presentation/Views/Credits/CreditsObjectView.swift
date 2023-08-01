//
//  CreditsObjectView.swift
//  CoreFeature
//
//  Created by byo on 2023/08/01.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

struct CreditsObjectView: View {
    @State var offsetX: CGFloat

    var body: some View {
        Circle()
            .frame(
                width: 200,
                height: 200
            )
            .offset(x: offsetX)
    }
}

struct CreditsObjectView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsObjectView(offsetX: 0)
    }
}
