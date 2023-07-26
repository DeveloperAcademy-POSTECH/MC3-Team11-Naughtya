//
//  SearchManager.swift
//  CoreFeature
//
//  Created by byo on 2023/07/20.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public final class SearchManager: ObservableObject {
    public static let shared: SearchManager = .init()

    @Published public var isSearching: Bool = false

    private init() {
    }
}
