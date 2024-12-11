
import SwiftUI

struct ChatRowView: View {
    @EnvironmentObject var chatVM: ChatViewModel
    var chat: ChatRoom
    let azuerTarget = Bundle.main.object(forInfoDictionaryKey: "AZURESTORAGE") as! String
    var currentUser = UserDefaults.standard.value(forKey: "nickName") as! String
    var body: some View {
        HStack(alignment: .top) {
            // 사용자 이미지
            if let otherUser = chat.participants.first(where: { $0 != currentUser }) {
                VStack(alignment: .center) {
									if let imageUrl = chatVM.userImages["\(otherUser)"], let url = URL(string: "\(imageUrl.addingURLPrefix())") {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } placeholder: {
                            Image(systemName: "person.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                }
                .padding(.trailing, 10)
            }
            
            VStack(alignment: .leading) {
                if let otherUser = chat.participants.first(where: { $0 != currentUser }) {
                    Text(otherUser)
                        .font(.headline)
                }
                
                Text(chatVM.lastMessages[chat.id] ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding(10)
    }
}

