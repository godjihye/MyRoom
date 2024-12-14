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
				Text("초대코드 \(userVM.inviteCode)")
					.font(.title)
					.fontWeight(.bold)
					.padding()
					.background {
						RoundedRectangle(cornerRadius: 10)
							.fill(.yellow)
					}
					.onAppear {
						if userVM.inviteCode == "" {
							userVM.getInviteCode()
						}
					}
				Button {
					UIPasteboard.general.string = userVM.inviteCode
					isCopySuccess = UIPasteboard.general.hasStrings
				} label: {
					Text(isCopySuccess ? "복사완료" : "복사하기")
				}
				.foregroundStyle(isCopySuccess ? .red : .accent)
				.buttonStyle(.bordered)
				
				Button {
					userVM.refreshInviteCode()
				} label: {
					Text("코드 재발급")
				}
				.foregroundStyle(.secondary)
				.buttonStyle(.bordered)
			}
			.navigationTitle("초대코드 발급")
    }
}

#Preview {
    InviteCodeView()
}
