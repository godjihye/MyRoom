//
//  JoinHomeView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/6/24.
//

import SwiftUI

struct JoinHomeView: View {
	@Environment(\.dismiss) private var dismiss
	@EnvironmentObject var userVM: UserViewModel
	
	@State private var inviteCode = ""
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("초대코드로 입장")
				.font(.largeTitle)
				.fontWeight(.bold)
			CustomTextField(icon: "barcode.viewfinder", placeholder: "예시) MYROOM", text: $inviteCode)
			WideImageButton(icon: "💌", title: "입장", backgroundColor: .accent) {
				userVM.joinHome(inviteCode: inviteCode)
				userVM.fetchUser()
			}
			.alert("방 입장", isPresented: $userVM.isMakeHomeAlert) {
				Button("확인", role: .cancel) {
					dismiss()
				}
			} message: {
				Text(userVM.message)
			}
			
		}
		.padding()
	}
}

#Preview {
	let userVM = UserViewModel()
	JoinHomeView().environmentObject(userVM)
}
