//
//  SignInWithKakaoView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/7/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

struct SignInWithKakaoView: View {
		@EnvironmentObject var userVM: UserViewModel

		var body: some View {
				kakaoLoginView
		}

		private var kakaoLoginView: some View {
				VStack {
						Button {
								kakaoLogin()
						} label: {
								Image("kakao_login_large_wide")
										.resizable()
										.frame(maxWidth: .infinity, maxHeight: 55)
						}
				}
		}
	func fetchUserInfo() {
			guard let _ = TokenManager.manager.getToken() else {
					print("No token available. Cannot fetch user info.")
					kakaoLogin()
					return
			}

			UserApi.shared.me { user, error in
					if let error = error {
							print("Failed to fetch user info: \(error.localizedDescription)")
					} else if let id = user?.id {
							print("User ID: \(id)")
							userVM.socialLogin(userName: id.description)
					}
			}
	}

		// MARK: - Kakao Login
	func kakaoLogin() {
			log("Kakao Login Start")
			if UserApi.isKakaoTalkLoginAvailable() {
					UserApi.shared.loginWithKakaoTalk { token, error in
							handleLoginResult(token: token, error: error)
					}
			} else {
					UserApi.shared.loginWithKakaoAccount { token, error in
							handleLoginResult(token: token, error: error)
					}
			}
	}

		// MARK: - Handle Login Result
	private func handleLoginResult(token: OAuthToken?, error: Error?) {
			if let error {
					log("Login failed: \(error.localizedDescription)")
			} else if let token {
					log("Login successful! Token: \(token.accessToken)")
					fetchUserInfo()
			} else {
					log("Unknown login error")
			}
	}

		// MARK: - Fetch User Info
	func checkAndFetchUser() {
		if TokenManager.manager.getToken() == nil {
					kakaoLogin()
			} else {
					refreshTokenIfNeeded()
			}
	}
	func refreshTokenIfNeeded() {
			// 토큰 매니저에서 현재 토큰 확인
			if let token = TokenManager.manager.getToken() {
					UserApi.shared.accessTokenInfo { (_, error) in
							if let error = error {
									print("❌ Token invalid or expired: \(error.localizedDescription)")
									// 토큰이 유효하지 않으면 로그인 다시 시도
									self.kakaoLogin()
							} else {
									print("✅ Token is still valid: \(token.accessToken)")
									self.fetchUserInfo() // 유효하면 사용자 정보 가져오기
							}
					}
			} else {
					print("❌ No token found. Initiating login.")
					kakaoLogin()
			}
	}

}

#Preview {
		SignInWithKakaoView()
}
