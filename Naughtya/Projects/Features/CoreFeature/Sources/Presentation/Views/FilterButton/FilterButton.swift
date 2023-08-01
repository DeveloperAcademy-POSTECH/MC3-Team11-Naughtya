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
            buildButton(filter: .all)
            Divider()
            buildButton(filter: .incompleted)
            buildButton(filter: .completed)
        }
        .opacity(filterManager.filter == .all ? 0.7 : 1)
        .menuButtonStyle(BorderlessButtonMenuButtonStyle())
    }

    private func buildButton(filter: FilterCategory) -> some View {
        Button(filter.title) {
            filterManager.filter = filter
        }
    }
}

struct FilterButton_Previews: PreviewProvider {
    static var previews: some View {
        FilterButton()
    }
}
