import SwiftUI

struct ChatView: View {
		@EnvironmentObject var chatVM: ChatViewModel
		@State private var newMessage = ""
		@State var roomId: String
		@State var loginUser: String
		
		@State var otherUser:String?

		var chat: ChatRoom?
		let azuerTarget = Bundle.main.object(forInfoDictionaryKey: "AZURESTORAGE") as! String
		
		var body: some View {
				VStack {
						Text("\(chatVM.roomName)")
								.font(.title)
								.padding()
						
						ScrollView {
								ForEach(chatVM.messages) { message in
										HStack {
												if message.senderId == loginUser {
														
														HStack {
																Spacer()
																Text(message.text)
																		.padding()
																		.background(Color.blue)
																		.cornerRadius(10)
																		.foregroundColor(.white)
																		.frame(maxWidth: 250, maxHeight: .infinity, alignment: .trailing)
																		.lineLimit(nil)
														}
												} else {
														
																HStack {
																		
																		if let imageUrl = chatVM.userImages[otherUser ?? ""], let url = URL(string: "\(imageUrl)") {
																				AsyncImage(url: url) { image in
																						image.resizable()
																								.scaledToFill()
																								.frame(width: 40, height: 40)
																								.clipShape(Circle())
																				} placeholder: {
																						ProgressView()
																								.progressViewStyle(CircularProgressViewStyle())
																								.frame(width: 40, height: 40)
																				}
																		} else {
																				Image(systemName: "person.circle")
																						.resizable()
																						.scaledToFit()
																						.frame(width: 40, height: 40)
																						.clipShape(Circle())
																		}
																}
														
														Text(message.text)
																.padding()
																.background(Color.gray.opacity(0.2))
																.cornerRadius(10)
																.foregroundColor(.black)
																.frame(maxWidth: 250, alignment: .leading)
												}
												Spacer()
										}
										.padding(.horizontal)
								}
						}
						
						HStack {
								TextField("메시지 입력", text: $newMessage)
										.textFieldStyle(RoundedBorderTextFieldStyle())
								Button(action: {
										let message = Message(
												id: UUID().uuidString,
												senderId: loginUser,
												text: newMessage,
												timestamp: Date().timeIntervalSince1970
										)
										chatVM.sendMessage(roomId: roomId, message: message)
										newMessage = ""
								}) {
										Image(systemName: "paperplane.fill")
												.foregroundColor(.blue)
								}
						}
						.padding()
				}
				.onAppear {
						chatVM.fetchMessages(roomId: roomId)
						chatVM.fetchRoomName(roomId: roomId, currentUserId: loginUser)
						
						if let chat = chat {
								otherUser = chat.participants.first(where: { $0 != loginUser })
						}
				}
		}
}
