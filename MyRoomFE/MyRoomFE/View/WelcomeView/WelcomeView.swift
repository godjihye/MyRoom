//
//  WelcomeView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/10/24.
//

import SwiftUI
private let gradientColors: [Color] = [
	.myroom1,
	.myroom2
]
struct WelcomeView: View {
	@Binding var isFirstLaunching: Bool
	var body: some View {
		TabView {
			WelcomePage()
			FeaturesPage(isFirstLaunching: $isFirstLaunching)
			HowToUsePage(isFirstLaunching: $isFirstLaunching)
		}
		.background(Gradient(colors: gradientColors))
		.tabViewStyle(.page)
	}
}

//#Preview {
//	WelcomeView()
//}
