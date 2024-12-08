//
//  SignInWithKakaoView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/7/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKUser

struct SignInWithKakaoView: View {
	@EnvironmentObject var userVM: UserViewModel
	var body: some View {
		VStack{
			Button {
				kakaoLogin()
			} label: {
				Image("kakao_login_large_wide")
					.resizable()
					.frame(maxWidth: .infinity, maxHeight: 55)
					.padding()
			}
		}
	}
	fileprivate func fetchUserInfo() {
		UserApi.shared.me { user, error1 in
			if let error1 {
				print(error1.localizedDescription)
			} else {
				if let id = user?.id {
					print("===> kakao 로그인 성공 kakao_user_id: \(id)")
					userVM.socialLogin(userName: id.description)
				}
			}
		}
	}
	
	func kakaoLogin() {
		if UserApi.isKakaoTalkLoginAvailable() {
			// 1. 카카오톡 앱으로 실행할 수 있으면 카카오톡으로 로그인
			UserApi.shared.loginWithKakaoTalk { token, error in
				if let error {
					print(error.localizedDescription)
				}
				//				} else {
				//					print(token!)
				//					fetchUserInfo()
				//				}
				UserApi.shared.me() { (user, error) in
					if let error = error {
						print(error)
					} else {
						if let user = user, let id = user.id {
								userVM.socialLogin(userName: id.description)
							log("===============================userVM.socialLogin(userName: id.description)=====================================")
						}
					}
				}
			}
		} else {
			// 2. 카카오톡 앱 실행할 수 없으면 웹으로 실행
			UserApi.shared.loginWithKakaoAccount { token, error in
				if let error {
					print(error.localizedDescription)
				} else {
					print(token!)
					fetchUserInfo()
				}
			}
		}
	}
}

#Preview {
	SignInWithKakaoView()
}
