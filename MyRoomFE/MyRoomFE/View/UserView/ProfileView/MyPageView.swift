//
//  MyPageView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/5/24.
//

import SwiftUI

struct MyPageView: View {
	@EnvironmentObject var userVM: UserViewModel
	var body: some View {
		NavigationStack {
				ScrollView {
					ProfileView()
					Divider()
					menuView
					Divider()
					logoutBtn
				}
			}
		}
	
	
	private var menuView: some View {
		VStack {
			NavigationLink {
				if let userInfo = userVM.userInfo {
					ProfileEditView(user: userInfo)
				}
			} label: {
				MyPageRow(icon: "👤", title: "회원정보 수정", backgroundColor: .myroom1)
			}
			NavigationLink {
				MyHomeView()
			} label: {
				MyPageRow(icon: "🏠", title: "집 정보 수정", backgroundColor: .myroom2)
			}
		}
	}
	
	private var logoutBtn: some View {
		Button {
			userVM.logout()
		} label: {
			Text("로그아웃하기")
				.foregroundStyle(.gray)
				.padding()
		}
	}
}

#Preview {
	let userVM = UserViewModel()
	MyPageView().environmentObject(userVM)
}
