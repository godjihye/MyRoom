import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var chatVM: ChatViewModel
    
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
                        // 구분선 추가
                        Divider()
                    }
                    .listStyle(.plain)
                    .navigationTitle("채팅목록")
                }
                .onAppear {
                    chatVM.fetchChatRooms()   // 채팅방 데이터 가져오기
                }
            }
        }
        //        detail: {
        //            Text("채팅 목록")
        //        }
    }
}

