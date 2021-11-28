//  SwiftUIWebView.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI
import WebKit

struct SwiftUIWebView: UIViewRepresentable {
    let url: URL?
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        return WKWebView(frame: .zero, configuration: config)   //frame CGRect
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let myURL = url else { return }
        let urlRequest = URLRequest(url: myURL)
        
        if uiView.currentReachabilityStatus == .notReachable {
            let str = "<p style=color:red>Document could not be accessed.</p><p>Check to be sure you are connected to the internet and then try again.</p>"
            let offlineContentHTML = "<meta name=viewport content=initial-scale=1.0/>" + "<div style=\"font-family: sans-serif; font-size: 15px\">" + str + "</div>"
            uiView.loadHTMLString(offlineContentHTML, baseURL: nil)
        } else {
            uiView.load(urlRequest)
            //webView.contentMode = .scaleToFill
        }
    }
}

