//
//  WebView.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/23/24.
//

import SwiftUI
import WebKit

struct MainWebView: View {
    let url = URL(string: "https://www.espn.com/nba/scoreboard")
    var body: some View {
        WebView(url: url!)
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

#Preview {
    MainWebView()
}

