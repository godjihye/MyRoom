//
//  Entry.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI

struct EntryView: View {
    var body: some View {
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
                ChatView(roomId: "soojeong",loginUser: "soojoeng",usedUser: "hangang").environmentObject(ChatViewModel())
                    .tabItem {
                        Text("chatTEST")
                    }
			}
    }
}

#Preview {
	let roomVM = RoomViewModel()
	let itemVM = ItemViewModel()
    let usedVM = UsedViewModel()
    let postVM = PostViewModel()
    EntryView().environmentObject(roomVM).environmentObject(itemVM).environmentObject(usedVM).environmentObject(postVM)
}
