//
//  SearchViewModel.swift
//  CoreFeature
//
//  Created by byo on 2023/07/20.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    private static let filterManager: FilterManager = .shared

    @Published var searchedText: String = ""

    init() {
    }

    var isSearching: Bool {
        !searchedText.isEmpty
    }

    func searchGlobally(text: String) {
        Self.filterManager.searchedText = text
    }
}
