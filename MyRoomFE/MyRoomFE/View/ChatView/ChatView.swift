//
//  ChatView.swift
//  MyRoomFE
//
//  Created by 이수정 on 12/3/24.
//
import SwiftUI

struct ChatView: View {
    @StateObject private var chatVM = ChatViewModel()
    @State private var newMessage = ""
    @State private var roomId: String
    @State private var loginUser: String
    @State private var usedUser: String
    @State private var loginUserImg:String?
    @State private var usedUserImg:String?
    
    
    var body: some View {
        VStack {
            Text("userName : \(chatVM.roomName)")
                .font(.title)
                .padding()
            ScrollView {
                ForEach(chatVM.messages) { message in
                    HStack {
                        if message.senderId == loginUser {
                            
                            VStack(alignment: .trailing) {
                                if let url = URL(string: loginUserImg) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                            .scaledToFill()
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        Image(systemName: "person.circle")
                                            .progressViewStyle(CircularProgressViewStyle())
                                            .frame(width: 40, height: 40)
                                            
                                    }
                                }
                                Text(message.text)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                            }
                            } else {
                                Text(message.text)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .foregroundColor(.black)
                                Spacer()
                            }
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
            }
        }
    }
    
    
    #Preview {
        let chatVM = ChatViewModel()
        ChatView(roomId: "soojeong",loginUser: "soojoeng",usedUser: "hangang").environmentObject(chatVM)
    }
