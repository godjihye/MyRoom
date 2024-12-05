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
	@State var isVaildEmail: Bool = true
	@State var isVaildPW: Bool = true
	@State private var emailOffset: CGFloat = 0
	 @State private var pwOffset: CGFloat = 0
	var body: some View {
		VStack {
			VStack {
				CustomTextField(icon: "person.fill", placeholder: "사용자ID", text: $userID)
					.onChange(of: userID) { oldValue, newValue in
						isVaildEmail = true
					}
				if !isVaildEmail {
					Text("이메일 형식으로 입력해주세요.")
						.font(.footnote)
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
				CustomTextField(icon: "lock.fill", placeholder: "비밀번호", text: $password, isSecured: true)
					.onChange(of: password) { oldValue, newValue in
						isVaildPW = true
					}
				if !isVaildPW {
					Text("8자 이상 입력해주세요.")
						.font(.footnote)
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
				WideImageButton(icon: "person.badge.key", title: "로  그  인", backgroundColor: .accent) {
					if !textFieldValidatorEmail(userID) {
						isVaildEmail = false
					}
					else if !textFieldValidatorPW(password) {
						isVaildPW = false
					} else {
						userVM.login(userName: userID, password: password)
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

func textFieldValidatorEmail(_ string: String) -> Bool {
		if string.count > 100 {
				return false
		}
		let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
		//let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
		return emailPredicate.evaluate(with: string)
}
func textFieldValidatorPW(_ string: String) -> Bool {
	string.count >= 8
}

#Preview {
	let userVM = UserViewModel()
	LoginView(userID: "wizard", password: "1234", isRegister: false).environmentObject(userVM)
}
