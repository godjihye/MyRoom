//
//  LoginView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/29/24.
//

import SwiftUI
import SVProgressHUD

struct LoginView: View {
	@EnvironmentObject var userVM: UserViewModel
	@State var userID:String = ""
	@State var password:String = ""
	@State var nickname: String = ""
	@State var isShowing = false
	@State var isRegister: Bool = false
	var body: some View {
		VStack {
			VStack {
				
				CustomTextField(icon: "person.fill", placeholder: "사용자ID", text: $userID)
				Text("이메일 형식으로 입력해주세요.")
					.font(.footnote)
					.foregroundStyle(.secondary)
				CustomTextField(icon: "lock.fill", placeholder: "비밀번호", text: $password, isSecured: true)
				Text("8자 이상 입력해주세요.")
					.font(.footnote)
					.foregroundStyle(.secondary)
				if isRegister {
					CustomTextField(icon: "person.fill", placeholder: "닉네임", text: $nickname)
				}
			}

			if isRegister {
				WideImageButton(icon: "person.badge.plus", title: "회원가입", backgroundColor: .green) {
					userVM.signUp(userName: userID, password: password, nickname: nickname)
				}
				.padding()
				.disabled(userID.isEmpty || password.isEmpty || nickname.isEmpty)
				.alert("회원가입", isPresented: $userVM.isJoinShowing) {
					Button("확인") {
						userVM.isJoinShowing = false
					}
				} message: {
					Text(userVM.message)
				}
				Button {
					isRegister = false
				} label: {
					Text("로그인으로 돌아가기")
				}
			} else {
				WideImageButton(icon: "person.badge.key", title: "로  그  인", backgroundColor: .orange) {
					SVProgressHUD.show()
					userVM.login(userName: userID, password: password)
				}
				.padding()
				.alert("로그인", isPresented: $userVM.isLoginError) {
					Button("확인") {
						userVM.isLoginError = false
					}
				} message: {
					Text(userVM.message)
				}
				Button {
					isRegister = true
				} label: {
					Text("회원가입하기")
				}

			}


		}
	}
}


#Preview {
	let userVM = UserViewModel()
	LoginView(userID: "wizard", password: "1234", isRegister: false).environmentObject(userVM)
}
