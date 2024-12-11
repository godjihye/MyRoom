//
//  LoginView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/6/24.
//

import SwiftUI

struct LoginView: View {
	var body: some View {
		
		NavigationStack {
			VStack {
				Image("logo")
					.resizable()
					.frame(width: 100, height: 80)
					.padding(.top, -80)
				socialLoginView
				NavigationLink(destination: EmailLoginView()) {
					Text("이메일로 로그인하기")
				}
			}
		}
	}
	private var socialLoginView: some View {
		VStack {
			SignInWithAppleView()
			SignInWithKakaoView()
		}
		.padding()
	}
}

#Preview {
	LoginView()
}
