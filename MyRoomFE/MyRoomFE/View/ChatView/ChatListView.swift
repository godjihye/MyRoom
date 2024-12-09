import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var chatVM: ChatViewModel
    @State var usedUser: String
    
    var body: some View {
        NavigationSplitView {
            ScrollView {
                LazyVStack {
                    ForEach(chatVM.chatRooms) { chatRoom in
                        NavigationLink() {
                            ChatView(roomId: chatRoom.id, loginUser: chatVM.currentUser,otherUserImg: chatVM.userImages["마루미"])
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
        } detail: {
            Text("채팅 목록")
        }
    }
}

