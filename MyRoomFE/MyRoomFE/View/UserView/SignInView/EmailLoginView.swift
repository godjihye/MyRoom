//
//  LoginView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/29/24.
//

import SwiftUI
import SVProgressHUD

struct EmailLoginView: View {
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
	@State var isVaildNick: Bool = true
	@State private var emailOffset: CGFloat = 0
	@State private var pwOffset: CGFloat = 0
	@State private var pwcheckOffset: CGFloat = 0
	@State private var nickOffset: CGFloat = 0
	
	@FocusState private var focusedField: Field?
	enum Field: Hashable {
		case email, password1, password2, nickname
	}
	
	var body: some View {
		VStack {
			logoAndTextImage
			emailTextField
			pwTextField
			if isRegister {
				pwCheckTextField
				nicknameTextField
				registerButton
			} else {
				loginButton
			}
		}
		.submitLabel(.next)
		.padding()
		.padding(.bottom, 50)
		.onAppear {
			UIApplication.shared.hideKeyboard()
		}
	}
	
	private var logoAndTextImage: some View {
		VStack(spacing: 0) {
			Image("logo")
				.resizable()
				.frame(width: 100, height: 80)
			
			Image(isRegister ? "registerImage" : "loginImage")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 80)
			
		}
	}
	
	private var emailTextField: some View {
		VStack(alignment: .leading) {
			Text("이메일 *")
				.fontWeight(.bold)
			CustomTextField(icon: "person.fill", placeholder: "예) myroom@gmail.com", text: $email)
				.focused($focusedField, equals: .email)
				.onSubmit { focusedField = .password1 }
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
		}
	}
	
	private var pwTextField: some View {
		VStack(alignment: .leading) {
			Text("비밀번호 *")
				.fontWeight(.bold)
			CustomTextField(icon: "lock.fill", placeholder: "영문, 숫자 조합 8~16자", text: $password1, isSecured: true)
				.focused($focusedField, equals: .password1) // 포커스 연결
				.onSubmit {
					if isRegister {
						focusedField = .password2
					} else {
						focusedField = nil
					}
				}
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
		}
	}
	
	private var pwCheckTextField: some View {
		VStack(alignment: .leading) {
			Text("비밀번호 확인 *")
				.fontWeight(.bold)
			CustomTextField(icon: "lock.fill", placeholder: "비밀번호와 똑같이 입력해주세요.", text: $password2, isSecured: true)
				.focused($focusedField, equals: .password2) // 포커스 연결
				.onSubmit { focusedField = .nickname }
				.onChange(of: password2) { oldValue, newValue in
					isEqualPW = password1.isEqualPW(newValue)
				}
			// 비밀번호, 비밀번호 확인이 같은지 검증
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
		}
	}
	
	private var nicknameTextField: some View {
		VStack(alignment: .leading) {
			if isRegister {
				Text("닉네임 *")
					.fontWeight(.bold)
				CustomTextField(icon: "person.fill", placeholder: "2자 이상 입력", text: $nickname)
					.focused($focusedField, equals: .nickname) // 포커스 연결
					.onSubmit { focusedField = nil }
				if !isVaildNick {
					Text("닉네임 2자 이상 입력해주세요.")
						.font(.footnote)
						.fontWeight(.bold)
						.foregroundStyle(.red)
						.offset(x: nickOffset)
						.onAppear(perform: {
							withAnimation(Animation.easeInOut(duration: 0.1)
								.repeatCount(10)) {
									self.nickOffset = -5
								}
						})
						.padding(.leading, 5)
				}
			}
		}
	}
	
	private var registerButton: some View {
		VStack {
			WideImageButton(icon: "person.badge.plus", title: "회원가입", backgroundColor: .green) {
				if !email.textFieldValidatorEmail() {
					isVaildEmail = false
				} else if !password1.textFieldValidatorPW() {
					isVaildPW = false
				} else if !password1.isEqualPW(password2) {
					isEqualPW = false
				} else if nickname.count < 2{
					isVaildNick = false
				} else {
					userVM.signUp(userName: email, password: password1, nickname: nickname)
				}
			}
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
			.padding(.top)
		}
		.padding(.top)
	}
	
	private var loginButton: some View {
		VStack {
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
			.alert("로그인", isPresented: $userVM.isLoginError) {
				Button("확인", role:.cancel) {
					userVM.isLoginError = false
				}
			} message: {
				Text(userVM.message)
			}
			HStack {
				Text("아직 회원이 아니신가요?")
					.foregroundStyle(.secondary)
				Button {
					isRegister = true
				} label: {
					Text("회원가입하기")
				}
			}
			.padding(.top)
		}
		.padding(.top)
	}
}

#Preview {
	let userVM = UserViewModel()
	EmailLoginView(email: "wizard", password1: "1234", isRegister: false).environmentObject(userVM)
}
