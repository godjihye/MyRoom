//
//  ChangePWView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/8/24.
//

import SwiftUI

struct ChangePWView: View {
	@Environment(\.dismiss) private var dismiss
	@EnvironmentObject var userVM: UserViewModel
	@State private var currentPW: String = ""
	@State private var newPW: String = ""
	@State private var newPWCheck: String = ""
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("비밀번호 변경")
				.font(.largeTitle)
				.bold()
			Spacer()
			VStack(alignment: .leading) {
				Text("현재 비밀번호 입력").bold()
				CustomTextField(icon: "lock", placeholder: "현재 비밀번호", text: $currentPW, isSecured: true)
				Text("새 비밀번호 입력").bold()
				CustomTextField(icon: "lock", placeholder: "새 비밀번호", text: $newPW, isSecured: true)
				Text("새 비밀번호 확인").bold()
				CustomTextField(icon: "lock", placeholder: "새 비밀번호 확인", text: $newPWCheck, isSecured: true)
			}
			.padding(.vertical)
			
			WideButton(title: "비밀번호 변경", backgroundColor: .red) {
				log("btn clicked")
				if newPW == newPWCheck {
					log("userVM.changepw 실행")
					userVM.changepw(cpw: currentPW, npw: newPW)
				}
			}
			.alert("비밀번호 변경", isPresented: $userVM.showAlert) {
				Button("확인", role: .cancel) {
					dismiss()
				}
			} message: {
				Text(userVM.message)
			}
			
			Spacer()
		}
		.padding()
	}
}

#Preview {
	ChangePWView()
}
