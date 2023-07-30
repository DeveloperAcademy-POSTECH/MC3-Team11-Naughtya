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

            ZStack {ResultBoardView()

//             LaunchView {
//                 ZStack {
//                     DashboardView()
//                     DragDropStageView(topPadding: 52)
//                 }

            }
            .frame(minWidth: 1174, minHeight: 756)
            .preferredColorScheme(.dark)
        }
    }
}
