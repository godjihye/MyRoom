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
		
		@Published var userImages = [String: String]()
		@Published var lastMessages = [String: String]()
		
		private var roomIdMapping: [String: String] = [:]
		
		private let db = Database.database().reference()
		
		
		//roomId 유무 체크
		func roomIdChk(roomId: String, completion: @escaping (Bool) -> Void) {
				print("roomIdChk start : \(roomId)")
				db.child("chats/\(roomId)/").observeSingleEvent(of: .value) { snapshot in
						if !snapshot.exists() {
								completion(true)
						}
				}
		}
		
		//채팅방만들기
		func createChatRoom(roomId: String, loginUser:String, usedUser:String,loginUserImg:String,usedUserImg:String, roomName:String) {
				print("createChatRoom start : \(roomId)")
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
		
		//채팅방목록 조회
		func fetchChatRooms() {
				var currentUser = UserDefaults.standard.value(forKey: "nickName") as! String
				print("fetchChatRoom start currentUser : \(currentUser)")
				
				db.child("users/\(currentUser)/chatRooms").observe(.value) { snapshot in
						let dispatchGroup = DispatchGroup() // 비동기 작업 순서 제어
						
						dispatchGroup.enter() // 작업 시작
						
						self.fetchChatRoomDetails(snapshot: snapshot) {
								dispatchGroup.leave() // 작업 완료
						}
						
						dispatchGroup.notify(queue: .main) {
								print("fetchChatRooms completed chatRooms : \(self.chatRooms)")
								self.fetchUserImages()  // 사용자 이미지 조회
								self.fetchLastMessages()  // 마지막 메시지 조회
						}
				}
		}
		
		//채팅방 데이터 조회
		func fetchChatRoomDetails(snapshot: DataSnapshot, completion: @escaping () -> Void) {
				print("fetchChatRoomDetails start ")
				
				guard let data = snapshot.value as? [String: String] else { return }
				
				for (index, (roomId, roomName)) in data.enumerated() {
						
						db.child("chats/\(roomId)/").observeSingleEvent(of: .value) { snapshot in
								if let chatData = snapshot.value as? [String: Any],
									 let participants = chatData["participants"] as? [String]
								{
										var imageUrls: [String: String] = [:]
										let dispatchGroup = DispatchGroup()
										
										for participant in participants {
												dispatchGroup.enter()
												self.db.child("users/\(participant)/imageUrl").observeSingleEvent(of: .value) { userSnapshot in
														if let imageUrl = userSnapshot.value as? String {
																imageUrls[participant] = imageUrl
														}
														dispatchGroup.leave() //이미지 조회 완료
												}
										}
										
										dispatchGroup.notify(queue: .main) { //이미지 조회 완료 후 데이터 입력
												if !self.chatRooms.contains(where: { $0.id == roomId }) { // 중복 방지
														let chatRoom = ChatRoom(
																id: roomId,
																roomName: roomName,
																participants: participants,
																imageUrls: imageUrls
														)
														DispatchQueue.main.async {
																self.chatRooms.append(chatRoom)
														}
														
														if index == data.count - 1 {
																completion()
														}
												}
										}
										
										
								}
						}
				}
		}
		
		//user프로필 조회
		func fetchUserImages() {
				print("fetchUserImages start ")
				db.child("users").observe(.value) { snapshot in
						guard let usersData = snapshot.value as? [String: Any] else { return }
						
						for (userId, userData) in usersData {
								if let user = userData as? [String: Any], let imageUrl = user["imageUrl"] as? String {
										self.userImages[userId] = imageUrl
								}
						}
						print("fetchUserImages completed : \(self.userImages)")
				}
		}
		
		//마지막 메세지 조회
		func fetchLastMessages() {
				print("fetchLastMessages start chatRooms : \(chatRooms)")
				let dispatchGroup = DispatchGroup() // 작업 그룹 생성
				
				for chatRoom in chatRooms {
						let roomId = chatRoom.id
						print("roomId는 : \(roomId)")
						
						dispatchGroup.enter() // 작업 시작
						db.child("chats/\(roomId)/messages")
								.queryOrderedByKey()
								.queryLimited(toLast: 1)
								.observeSingleEvent(of: .value) { snapshot, error in
										print("lasemessage snapshot : \(snapshot)")
										
										if let messagesData = snapshot.value as? [String: Any],
											 let lastMessage = messagesData.values.first as? [String: Any] {
												DispatchQueue.main.async {
														self.lastMessages[roomId] = lastMessage["text"] as? String ?? ""
												}
										}
										dispatchGroup.leave() // 작업 완료
								}
				}
				
				dispatchGroup.notify(queue: .main) {
						print("fetchLastMessages completed : \(self.lastMessages)")
				}
		}
		
		// 자신에게 보여지는 채팅방명이 상대방 아이디로 보일수 있도록 셋팅
		func fetchRoomName(roomId: String, currentUserId: String) {
				db.child("chats/\(roomId)/participants").observeSingleEvent(of: .value) { snapshot in
						// 채팅 참여자정보
						guard let participants = snapshot.value as? [String], participants.count == 2 else { return }
						
						// 채팅방 이름 설정 (상대방 이름으로)
						if participants[0] == currentUserId {
								self.roomName = participants[1] // user1이 user2의 채팅방을 열었을 때
						} else {
								self.roomName = participants[0] // user2가 user1의 채팅방을 열었을 때
						}
				}
				print("fetchRoomName completed : \(roomName)");
		}
		
		
}
