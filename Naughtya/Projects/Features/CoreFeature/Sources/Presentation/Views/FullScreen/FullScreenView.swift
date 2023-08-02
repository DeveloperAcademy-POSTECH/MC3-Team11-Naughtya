//
//  FullScreenView.swift
//  CoreFeature
//
//  Created by byo on 2023/08/02.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI

struct FullScreenView<Content: View>: NSViewRepresentable {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    func makeNSView(context: Context) -> NSView {
        let hostingController = NSHostingController(rootView: content)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.contentViewController = hostingController
        window.isReleasedWhenClosed = false
        window.makeKeyAndOrderFront(nil)
        window.toggleFullScreen(nil)
        return NSView()
    }

    func updateNSView(_ nsView: NSView, context: Context) {
    }
}
