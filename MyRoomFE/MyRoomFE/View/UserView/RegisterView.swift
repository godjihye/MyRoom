//
//  RegisterView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/5/24.
//

import SwiftUI
import SVProgressHUD

struct RegisterView: View {
	@EnvironmentObject var userVM: UserViewModel
	@State var email:String = ""
	@State var password1:String = ""
	@State var password2:String = ""
	@State var nickname: String = ""
	@State var isShowing = false
	@State var isVaildEmail: Bool = true
	@State var isVaildPW: Bool = true
	@State private var emailOffset: CGFloat = 0
	@State private var pwOffset: CGFloat = 0
	var body: some View {
		VStack {
			Text("회원가입")
				.font(.largeTitle)
				.fontWeight(.bold)
			VStack {
				CustomTextField(icon: "person.fill", placeholder: "사용자ID", text: $email)
					.onChange(of: email) { oldValue, newValue in
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
				CustomTextField(icon: "lock.fill", placeholder: "비밀번호", text: $password1, isSecured: true)
					.onChange(of: password1) { oldValue, newValue in
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
				CustomTextField(icon: "lock.fill", placeholder: "비밀번호", text: $password2, isSecured: true)
				CustomTextField(icon: "person.fill", placeholder: "닉네임", text: $nickname)
			}
			
			WideImageButton(icon: "person.badge.plus", title: "회원가입", backgroundColor: .green) {
				userVM.signUp(userName: email, password: password1, nickname: nickname)
			}
			.padding()
			.disabled(email.isEmpty || password1.isEmpty || password2.isEmpty || nickname.isEmpty)
			.alert("회원가입", isPresented: $userVM.isJoinShowing) {
				Button("확인") {
					userVM.isJoinShowing = false
				}
			} message: {
				Text(userVM.message)
			}
		}
	}
}

#Preview {
	let userVM = UserViewModel()
	RegisterView(email: "wizard", password1: "1234", password2: "1234", nickname: "마루미").environmentObject(userVM)
}
