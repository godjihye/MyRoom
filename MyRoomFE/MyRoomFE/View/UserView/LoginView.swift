//
//  LoginView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/29/24.
//

import SwiftUI
import SVProgressHUD

struct LoginView: View {
		//@EnvironmentObject var member:MemberViewModel
		@State var userID:String = ""
		@State var password:String = ""
		@State var isShowing = false
		var body: some View {
		
				VStack {
						VStack {
								CustomTextField(icon: "person.fill", placeholder: "사용자ID", text: $userID)
								CustomTextField(icon: "lock.fill", placeholder: "비밀번호", text: $password, isSecured: true)
						}
						VStack{
								WideImageButton(icon: "person.badge.key", title: "로  그  인", backgroundColor: .orange) {
										SVProgressHUD.show()
										//member.login(userName: userID, password: password)
								}
//								.alert("로그인", isPresented: $member.isJoinShowing) {
//										Button("확인") {
//												//member.isLoginError = false
//										}
//								} message: {
//										//Text(member.message)
//								}
								
								WideImageButton(icon: "person.badge.plus", title: "회원가입", backgroundColor: .green) {
										// member.join(userName: userID, password: password)
								}
//								.alert("회원가입", isPresented: $member.isLoginError) {
//										Button("확인") {
//												// member.isJoinShowing = false
//										}
//								} message: {
//										// Text(member.message)
//								}
							}.padding()
						
				}
		}
}


#Preview {
		//let member = MemberViewModel()
		LoginView(userID: "wizard", password: "1234")/*.environmentObject(member)*/
}
