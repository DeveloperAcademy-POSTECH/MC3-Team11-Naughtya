//
//  GifImageView.swift
//  CoreFeature
//
//  Created by byo on 2023/07/31.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import SwiftUI
import WebKit

public struct GifImageView: NSViewRepresentable {
    private let fileName: String

    public init(fileName: String) {
        self.fileName = fileName
    }

    public func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        guard let url = Bundle.module.url(forResource: fileName, withExtension: "gif"),
              let data = try? Data(contentsOf: url) else {
            return webView
        }
        webView.load(
            data,
            mimeType: "image/gif",
            characterEncodingName: "UTF-8",
            baseURL: url.deletingLastPathComponent()
        )
        return webView
    }

    public func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.reload()
    }
}
