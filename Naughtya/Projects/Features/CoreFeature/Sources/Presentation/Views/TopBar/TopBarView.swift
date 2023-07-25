//
//  TopBarView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/20.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct TopBarView: View {
    public init() {
    }

    public var body: some View {
        HStack {
            Spacer()
            SearchView()
                .frame(width: 400)
            Spacer()
        }
        .frame(height: 60)
    }
}

struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
        TopBarView()
    }
}
