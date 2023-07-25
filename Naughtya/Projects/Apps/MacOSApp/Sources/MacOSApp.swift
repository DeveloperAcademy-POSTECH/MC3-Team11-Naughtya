//
//  MacOSApp.swift
//  MacOSApp
//
//  Created by byo on 2023/07/15.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI
import MacOSCoreFeature

@main
struct MacOSApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                DashboardView()
                    .tabItem {
                        Text("홈")
                    }
                ChatView()
                    .tabItem {
                        Text("완료(성과)")
                    }
            }
        }
    }
}
