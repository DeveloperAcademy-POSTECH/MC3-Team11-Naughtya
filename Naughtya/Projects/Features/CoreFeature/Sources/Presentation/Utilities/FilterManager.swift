//
//  FilterManager.swift
//  CoreFeature
//
//  Created by byo on 2023/07/20.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public final class FilterManager: ObservableObject {
    public static let shared: FilterManager = .init()

    @Published public var filter: FilterCategory?
    @Published public var searchedText: String = ""

    private init() {
    }

    public var isSearching: Bool {
        !searchedText.isEmpty
    }
}
