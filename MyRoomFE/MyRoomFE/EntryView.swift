//
//  Entry.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI

struct EntryView: View {
	@EnvironmentObject var userVM: UserViewModel
	var body: some View {
		if userVM.isLoggedIn {
			TabView {
				HomeView()
					.environmentObject(RoomViewModel()).environmentObject(ItemViewModel())
					.tabItem {
						Image(systemName: "house")
						Text("홈")
					}
			}
		} else {
			LoginView()
				.transition(.move(edge: .bottom))
				.animation(.easeInOut, value: userVM.isLoggedIn)
		}
	}
}

#Preview {
	let roomVM = RoomViewModel()
	let itemVM = ItemViewModel()
	let userVM = UserViewModel()
	EntryView().environmentObject(roomVM).environmentObject(itemVM).environmentObject(userVM)
}
