//
//  WelcomePage.swift
//  Welcome
//
//  Created by jhshin on 12/10/24.
//

import SwiftUI

struct WelcomePage: View {
	var body: some View {
		VStack {
			Spacer()
			Image("logo")
				.resizable()
				.renderingMode(.template)
				.foregroundStyle(.white)
				.opacity(0.8)
				.frame(width: 200, height: 160)
			
			Text("마룸에 오신 걸 환영합니다.")
				.font(.title2)
				.fontWeight(.bold)
				.foregroundStyle(.white)
				.opacity(0.8)
				.padding()
		}
		.padding()
	}
}

#Preview {
	WelcomePage()
}
