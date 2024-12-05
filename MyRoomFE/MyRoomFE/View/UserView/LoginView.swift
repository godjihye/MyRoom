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
	@State var email:String = ""
	@State var password1:String = ""
	@State var password2:String = ""
	@State var nickname: String = ""
	@State var isShowing = false
	@State var isRegister: Bool = false
	@State var isVaildEmail: Bool = true
	@State var isVaildPW: Bool = true
	@State var isEqualPW: Bool = true
	@State private var emailOffset: CGFloat = 0
	@State private var pwOffset: CGFloat = 0
	@State private var pwcheckOffset: CGFloat = 0
	var body: some View {
		VStack {
			Text(isRegister ? "회원가입" : "로그인")
				.font(.largeTitle)
				.fontWeight(.bold)
			VStack {
				CustomTextField(icon: "person.fill", placeholder: "이메일(예시: myroom@gmail.com)", text: $email)
					.onChange(of: email) { oldValue, newValue in
						isVaildEmail = true
					}
				if !isVaildEmail {
					Text("이메일 형식으로 입력해주세요.")
						.font(.footnote)
						.fontWeight(.bold)
						.foregroundStyle(.red)
						.offset(x: emailOffset)
						.onAppear(perform: {
							withAnimation(Animation.easeInOut(duration: 0.1)
								.repeatCount(10)) {
									self.emailOffset = -5
								}
						})
						.padding(.leading, 5)
				}
				CustomTextField(icon: "lock.fill", placeholder: "비밀번호 (8자 이상으로 입력해주세요.)", text: $password1, isSecured: true)
					.onChange(of: password1) { oldValue, newValue in
						isVaildPW = true
					}
				if !isVaildPW {
					Text("8자 이상 입력해주세요.")
						.font(.footnote)
						.fontWeight(.bold)
						.foregroundStyle(.red)
						.offset(x: pwOffset)
						.onAppear(perform: {
							withAnimation(Animation.easeInOut(duration: 0.1)
								.repeatCount(10)) {
									self.pwOffset = -5
								}
						})
						.padding(.leading, 5)
				}
				if isRegister {
					CustomTextField(icon: "lock.fill", placeholder: "비밀번호 확인", text: $password2, isSecured: true)
						.onChange(of: password2) { oldValue, newValue in
							isEqualPW = password1.isEqualPW(newValue)
						}
					if !isEqualPW {
						Text("비밀번호가 틀립니다.")
							.font(.footnote)
							.fontWeight(.bold)
							.foregroundStyle(.red)
							.offset(x: pwcheckOffset)
							.onAppear(perform: {
								withAnimation(Animation.easeInOut(duration: 0.1)
									.repeatCount(10)) {
										self.pwcheckOffset = -5
									}
							})
							.padding(.leading, 5)
					}
					CustomTextField(icon: "person.fill", placeholder: "닉네임(2자 이상 입력해주세요.)", text: $nickname)
				}
			}

			if isRegister {
				WideImageButton(icon: "person.badge.plus", title: "회원가입", backgroundColor: .green) {
					if !email.textFieldValidatorEmail() {
						isVaildEmail = false
					} else if !password1.textFieldValidatorPW() {
						isVaildPW = false
					} else if !password1.isEqualPW(password2) {
						isEqualPW = false
					} else {
						userVM.signUp(userName: email, password: password1, nickname: nickname)
					}
				}
				.padding()
				.disabled(email.isEmpty || password1.isEmpty || nickname.isEmpty)
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
				WideImageButton(icon: "person.badge.key", title: "로  그  인", backgroundColor: .accent) {
					if !email.textFieldValidatorEmail() {
						isVaildEmail = false
					}
					else if !password1.textFieldValidatorPW() {
						isVaildPW = false
					} else {
						userVM.login(userName: email, password: password1)
					}
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
	LoginView(email: "wizard", password1: "1234", isRegister: false).environmentObject(userVM)
}
