//
//  UsedWebView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//

import SwiftUI
import WebKit

struct UsedWebView: UIViewRepresentable {
	var url: URL
	
	func makeUIView(context: Context) -> WKWebView {
		return WKWebView()
	}
	
	func updateUIView(_ uiView: WKWebView, context: Context) {
		let request = URLRequest(url: url)
		uiView.load(request)
	}
	
	
}
