//
//  ChatViewModel.swift
//  MyRoomFE
//
//  Created by 이수정 on 12/3/24.
//

import Firebase

class ChatViewModel: ObservableObject {
    @Published var chatRooms: [ChatRoom] = []
    @Published var messages: [Message] = []
    @Published var roomName: String = ""
    
    private let db = Database.database().reference()
    
    
    //채팅방만들기
    func createChatRoom(roomId: String, loginUser:String, usedUser:String,loginUserImg:String,usedUserImg:String, roomName:String) {
        let participants = [loginUser,usedUser]
        let userImages = [loginUserImg,usedUserImg]
        let chatRoomData: [String: Any] = [
            "participants": participants,
            "name" : roomName
        ]
        
        db.child("chats/\(roomId)").setValue(chatRoomData) { error, _ in
            if let error = error {
                print("Failed to create chat room: \(error.localizedDescription)")
            } else {
                //user정보 저장
                self.addParticipantsToUsers(roomId: roomId, roomName: roomName, participants: participants,userImages:userImages)
                print("Chat room created successfully.")
            }
        }
    }
    
    //user정보 셋팅
    private func addParticipantsToUsers(roomId: String, roomName: String, participants: [String],userImages:[String]) {
        for (index,userId) in participants.enumerated() {
            let userChatRoomPath = "users/\(userId)/chatRooms/\(roomId)"
            let userImagePath = "users/\(userId)/imageUrl"
            
            //채팅방 정보 추가
            db.child(userChatRoomPath).setValue(roomName) { error, _ in
                if let error = error {
                    print("Failed to add chat room to user \(userId): \(error.localizedDescription)")
                } else {
                    print("Chat room \(roomId) successfully added to user \(userId).")
                }
            }
            
            //사용자이미지 추가
            let userImageUrl = userImages[index] // 각 사용자별 이미지 URL
            db.child(userImagePath).setValue(userImageUrl) { error, _ in
                if let error = error {
                    print("Failed to add image URL for user \(userId): \(error.localizedDescription)")
                } else {
                    print("Image URL successfully added for user \(userId).")
                }
            }
        }
    }
    
    //메세지 저장
    func sendMessage(roomId: String, message: Message) {
        guard let messageId = db.child("chats/\(roomId)/messages").childByAutoId().key else { return }
        
        let messageData: [String: Any] = [
            "senderId": message.senderId,
            "text": message.text,
            "timestamp": ServerValue.timestamp()
        ]
        
        db.child("chats/\(roomId)/messages/\(messageId)").setValue(messageData) { error, _ in
            if let error = error {
                print("Failed to send message: \(error.localizedDescription)")
            }
        }
    }
    
    //메세지 조회
    func fetchMessages(roomId: String) {
        db.child("chats/\(roomId)/messages").queryOrdered(byChild: "timestamp").observe(.value) { snapshot in
            var newMessages: [Message] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let dict = childSnapshot.value as? [String: Any],
                   let senderId = dict["senderId"] as? String,
                   let text = dict["text"] as? String,
                   let timestamp = dict["timestamp"] as? Double {
                    let message = Message(id: childSnapshot.key, senderId: senderId, text: text, timestamp: timestamp)
                    newMessages.append(message)
                }
            }
            self.messages = newMessages
        }
    }
    
    func fetchChatRooms(userId: String) {
        db.child("users/\(userId)/chatRooms").observe(.value) { snapshot, error in
            var rooms: [ChatRoom] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let roomId = childSnapshot.key as String?,
                   let roomName = childSnapshot.value as? String {
                    //                    rooms.append(ChatRoom(id: roomId, name: roomName))
                }
            }
            DispatchQueue.main.async {
                self.chatRooms = rooms
            }
        }
    }
    
    func fetchRoomName(roomId: String, currentUserId: String) {
        db.child("chats/\(roomId)/participants").observeSingleEvent(of: .value) { snapshot in
            // 참여자 정보 가져오기
            guard let participants = snapshot.value as? [String], participants.count == 2 else { return }
            
            // 채팅방 이름 설정 (상대방 이름으로 설정)
            if participants[0] == currentUserId {
                self.roomName = participants[1] // user1이 user2의 채팅방을 열었을 때
            } else {
                self.roomName = participants[0] // user2가 user1의 채팅방을 열었을 때
            }
        }
        print("fetchRoomName complete : \(roomName)");
    }
    
}
