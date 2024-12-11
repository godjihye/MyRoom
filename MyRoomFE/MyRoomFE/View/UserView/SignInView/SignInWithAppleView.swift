//
//  SignInWithAppleView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/7/24.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleView: View {
	@EnvironmentObject var userVM: UserViewModel
	@State var email: String?
	
	var body: some View {
		if let email {
			Text(email)
		}
		SignInWithAppleButton(.continue, onRequest: configureRequest, onCompletion: handleAuthorization)
			.frame(height: 60)
	}
	
	func configureRequest(_ request: ASAuthorizationAppleIDRequest) {
		request.requestedScopes = [.email]
	}
	func handleAuthorization(_ result: Result<ASAuthorization, Error>) {
		switch result {
		case .success(let auth):
			if let credential = auth.credential as? ASAuthorizationAppleIDCredential {
				// self.userId = credential.user
				self.email = credential.email
				if let email = self.email {
					userVM.socialLogin(userName: email)
				}
			}
		case .failure(let error):
			print("Failed Sign in \(error.localizedDescription)")
		}
	}
}

#Preview {
	SignInWithAppleView()
}
