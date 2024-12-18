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
	@State private var isDiffPW: Bool = false
	@State private var diffPWOffset: CGFloat = 0
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
				if isDiffPW {
					Text("비밀번호가 틀립니다.")
						.font(.footnote)
						.fontWeight(.bold)
						.foregroundStyle(.red)
						.offset(x: diffPWOffset)
						.onAppear(perform: {
							withAnimation(Animation.easeInOut(duration: 0.1)
								.repeatCount(10)) {
									self.diffPWOffset = -5
								}
						})
						.padding(.leading, 5)
				}
			}
			.padding(.vertical)
			
			Button {
				log("btn clicked")
				if newPW == newPWCheck {
					log("userVM.changepw 실행")
					userVM.changepw(cpw: currentPW, npw: newPW)
				} else {
					isDiffPW = true
				}
			} label: {
				WideButtonLabel(title: "비밀번호 변경", backgroundColor: .red)
			}
			.alert("비밀번호 변경", isPresented: $userVM.isShowingChangePW) {
				Button("확인", role: .cancel) {
					dismiss()
				}
			} message: {
				Text(userVM.changePWMessage)
			}
			
			Spacer()
		}
		.padding()
	}
}

#Preview {
	ChangePWView()
}
