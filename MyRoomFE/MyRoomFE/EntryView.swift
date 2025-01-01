//
//  Entry.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI

struct EntryView: View {
	@EnvironmentObject var userVM: UserViewModel
	@EnvironmentObject var roomVM: RoomViewModel
	var body: some View {
		if userVM.isLoggedIn {
			TabView {
				HomeView()
					.environmentObject(RoomViewModel()).environmentObject(ItemViewModel())
					.tabItem {
						Image(systemName: "house")
						Text("홈")
					}
				UsedListView().environmentObject(UsedViewModel())
					.tabItem {
						Image(systemName: "plus")
						Text("중고거래")
					}
				PostListView().environmentObject(PostViewModel())
					.tabItem {
						Image(systemName: "person.3.fill")
						Text("커뮤니티")
					}
				ChatListView().environmentObject(ChatViewModel())
					.tabItem {
						Image(systemName: "ellipsis.message.fill")
						Text("채팅목록")
					}
//				MyPageView()
//					.tabItem {
//						Image(systemName: "person.fill")
//						Text("마이페이지")
//					}
                AzureServicesSpeech()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Test")
                    }
			}
			.tint(.black)
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
	let usedVM = UsedViewModel()
	let postVM = PostViewModel()
	EntryView().environmentObject(roomVM).environmentObject(itemVM).environmentObject(usedVM).environmentObject(postVM).environmentObject(userVM)
}
