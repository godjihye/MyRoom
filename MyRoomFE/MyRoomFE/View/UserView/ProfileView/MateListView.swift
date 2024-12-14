//
//  MateListView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/12/24.
//

import SwiftUI

struct MateListView: View {
	@EnvironmentObject var userVM: UserViewModel
	@State private var showInviteCode: Bool = false
	@State private var isCopySuccess: Bool = false
	let userId = UserDefaults.standard.integer(forKey: "userId")
	var body: some View {
		NavigationStack {
			VStack {
				if UserDefaults.standard.integer(forKey: "homeId") < 1 {
					noHomeView
				} else {
					mateList
					Spacer()
					NavigationLink(destination: InviteCodeView()){
						WideButtonLabel(title: "초대코드 발급", backgroundColor: .myroom2)
						
					}.padding()
				}
			}
		}
		.navigationTitle("동거인 목록")
	 .navigationBarTitleDisplayMode(.inline)
	}
	private var addMate: some View {
				Button {
					userVM.getInviteCode()
					showInviteCode = true
				} label: {
					Text("동거인 추가하기")
						.padding(.bottom)
				}
	}

private var noHomeView: some View {
	Text("집을 먼저 등록해야 동거인 추가가 가능합니다.")
		.font(.headline)
		.foregroundStyle(.indigo)
		.padding(.bottom)
}
	private var inviteCode: some View {
		HStack {
			Text("초대코드 \(userVM.inviteCode)")
				.fontWeight(.bold)
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
	}
	private var mateList: some View {
		List {
			if let mates = userVM.userInfo?.mates {
				ForEach(mates) { mate in
					if mate.id != userId {
						ProfileRow(mate: mate)
					}
				}
			} else {
				Text("추가된 동거인이 없습니다.")
			}
		}
		.listStyle(.plain)
	}
}

#Preview {
	let userVM = UserViewModel()
	MateListView().environmentObject(userVM)
}
