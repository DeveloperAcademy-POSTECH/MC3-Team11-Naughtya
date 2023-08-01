//
//  UserDefaultsManager.swift
//  CoreFeature
//
//  Created by Greed on 2023/08/01.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    private static let hasAppearedKey = "hasAppearedKey"

    static func setHasAppeared(_ hasAppeared: Bool) {
        UserDefaults.standard.set(hasAppeared, forKey: hasAppearedKey)
    }

    static func getHasAppeared() -> Bool {
        return UserDefaults.standard.bool(forKey: hasAppearedKey)
    }
}
