//
//  FilterButton.swift
//  CoreFeature
//
//  Created by byo on 2023/07/27.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

public struct FilterButton: View {
    @ObservedObject private var filterManager = FilterManager.shared

    public init() {
    }

    public var body: some View {
        MenuButton(label: Image(systemName: "slider.horizontal.3")) {
            ForEach(FilterType.allCases, id: \.self) { filter in
                Button(filter.title) {
                    filterManager.filter = filter
                }
            }
        }
        .menuButtonStyle(BorderlessButtonMenuButtonStyle())
    }
}

struct FilterButton_Previews: PreviewProvider {
    static var previews: some View {
        FilterButton()
    }
}
