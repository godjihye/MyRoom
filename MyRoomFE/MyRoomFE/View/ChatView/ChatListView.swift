import SwiftUI

struct ChatListView: View {
	@EnvironmentObject var chatVM: ChatViewModel
	var chatUsedRoomName:String?
	
	var currentUser = UserDefaults.standard.string(forKey: "nickName")
	
	var body: some View {
		NavigationView {
			ScrollView {
				LazyVStack {
					ForEach(chatVM.chatRooms) { chatRoom in
						NavigationLink() {
							ChatView(roomId: chatRoom.id, loginUser: currentUser!, chat: chatRoom).environmentObject(chatVM)
						} label: {
							ChatRowView(chat: chatRoom).environmentObject(chatVM).padding(.horizontal)
						}
						
						Divider()
					}
					.listStyle(.plain)
					.navigationTitle("채팅목록")
				}
				.onAppear {
					
					if let chatUsedRoomName { //특정 게시글의 채팅목록 가져오기
						chatVM.fetchUsedChatRooms(chatRoomName: chatUsedRoomName)
					}else{ //전체 채팅목록 가져오기
						chatVM.fetchChatRooms()
					}
				}
			}
		}
		//        detail: {
		//            Text("채팅 목록")
		//        }
	}
}
