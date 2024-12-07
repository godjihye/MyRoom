//
//  SignInWithAppleView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/7/24.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleView: View {
	// @State var userId: String?
	// @State var fullName: PersonNameComponents?
	@State var email: String?
	
		var body: some View {

//				if let userId {
//					VStack {
//						Text("UserId: \(userId)")
//						if let email {
//							Text("Email: \(email)")
//						}
//						if let fullName {
//							Text("FullName: \(fullName.familyName!) \(fullName.givenName!)")
//						}
//					}
				
				SignInWithAppleButton(.continue, onRequest: configureRequest, onCompletion: handleAuthorization)
				.frame(height: 60)
				.padding(.horizontal)
			}
		
	func configureRequest(_ request: ASAuthorizationAppleIDRequest) {
		request.requestedScopes = [.fullName, .email]
	}
	func handleAuthorization(_ result: Result<ASAuthorization, Error>) {
		switch result {
		case .success(let auth):
			if let credential = auth.credential as? ASAuthorizationAppleIDCredential {
				// self.userId = credential.user
				self.email = credential.email
				// self.fullName = credential.fullName
			}
		case .failure(let error):
			print("Failed Sign in \(error.localizedDescription)")
		}
	}
}

#Preview {
		SignInWithAppleView()
}
