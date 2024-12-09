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
				Image("logo-light")
				SignInWithAppleView()
				SignInWithKakaoView()
				NavigationLink(destination: EmailLoginView()) {
					Text("이메일로 로그인하기")
				}
			}
		}
		
	}
}

#Preview {
	LoginView()
}
