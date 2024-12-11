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
	var body: some View {
		TabView {
			WelcomePage()
			FeaturesPage()
			HowToUsePage()
		}
		.background(Gradient(colors: gradientColors))
		.tabViewStyle(.page)
	}
}

#Preview {
	WelcomeView()
}
