//
//  InviteCodeView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/14/24.
//

import SwiftUI

struct InviteCodeView: View {
	@EnvironmentObject var userVM: UserViewModel
	@State private var isCopySuccess: Bool = false
	
	var body: some View {
		VStack {
			VStack {
				Text("\(userVM.userInfo?.homeUser?.homeName ?? "") 초대코드")
					.font(.title2)
					.fontWeight(.bold)
				
				Text("\(userVM.inviteCode)")
					.font(.system(size: 40, weight: .black, design: .rounded))
					.kerning(3)
					.onAppear {
						log(userVM.inviteCode)
						if userVM.inviteCode == "" {
							userVM.getInviteCode()
						}
					}
			}
			.padding()
				.background {
					RoundedRectangle(cornerRadius: 10)
						.stroke(.black)
				}
			HStack {
				Button {
					UIPasteboard.general.string = userVM.inviteCode
					isCopySuccess = UIPasteboard.general.hasStrings
				} label: {
					Text(isCopySuccess ? "복사완료" : "복사하기")
				}
				.foregroundStyle(isCopySuccess ? .red : .accent)
				
				Button {
					userVM.refreshInviteCode()
					isCopySuccess = false
				} label: {
					Text("코드 재발급하기")
				}
				.foregroundStyle(.secondary)
			}
			.padding()
		}
		.navigationTitle("초대코드")
	}
}

#Preview {
	InviteCodeView()
}
