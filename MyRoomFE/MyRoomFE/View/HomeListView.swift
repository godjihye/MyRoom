//
//  HomeListView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI

struct HomeListView: View {
	@EnvironmentObject var roomVM: RoomViewModel
	@State private var isShowingAddRoomView: Bool = false
	@State private var isShowingAddLocationView: Bool = false
	@State private var isShowingAlert: Bool = false
	@State private var removeRoomId: Int = 0
	@State private var isShowingAlertRemove: Bool = false
	
	var body: some View {
		NavigationStack {
			VStack {
				// title
				HStack {
					Text("Home")
						.font(.title)
						.bold()
					Spacer()
					Menu {
						Button("방 추가하기") {
							self.isShowingAddRoomView = true
						}
						Button("위치 추가하기"){
							self.isShowingAddLocationView = true
						}
					} label: {
						Image(systemName: "plus")
							.font(.title2)
							.bold()
					}
				}
				.padding()
				
				// Room - Location List
				if !roomVM.rooms.isEmpty {
					List {
						ForEach(roomVM.rooms) { (room: Room) in
							Section(header: HStack {
								Text(room.roomName)
								Spacer()
								NavigationLink("편집") {
									AddRoomView(title: "방 정보 편집", roomName: room.roomName, roomDesc: room.roomDesc) { roomName, roomDesc in
										Task {
											await roomVM.editRoom(roomId: room.id, roomName: roomName, roomDesc: roomDesc)
											await roomVM.fetchRooms()
										}
									}
								}
								.font(.system(size: 15))
								.foregroundStyle(.secondary)
								Button {
									isShowingAlert = true
									removeRoomId = room.id
								} label: {
									Text("삭제")
										.font(.system(size: 15))
										.foregroundStyle(.red)
								}
							}) {
								ForEach(room.locations) { location in
									NavigationLink {
										ItemListView(location: location)
									} label: {
										Text(location.locationName)
									}
								}
							}
						}
					}
					.refreshable {
						Task {
							await roomVM.fetchRooms()
						}
					}
				} else {
					VStack {
						Text("서버 연결을 확인해주세요!")
						Button("다시 시도하기") {
							Task {
								await roomVM.fetchRooms()
							}
						}
					}
					.padding(.top, 250)
				}
				Spacer()
			}
			.background(Color.background)
			.sheet(isPresented: $isShowingAddRoomView) {
				AddRoomView {roomName, roomDesc in
					Task {
						await roomVM.addRoom(roomName: roomName, roomDesc: roomDesc)
						await roomVM.fetchRooms()
					}
				}
			}
			.sheet(isPresented: $isShowingAddLocationView) {
				AddLocationView(rooms: roomVM.rooms) { roomId, locationName, locationDesc in
					Task { await roomVM.addLocation(locationName: locationName, locationDesc: locationDesc, roomId: roomId)
						await roomVM.fetchRooms()}
				}
			}
			.alert(isPresented: $isShowingAlert) {
				Alert(
					title: Text("방 삭제 확인"),
					message: Text("방을 삭제하시겠습니까?\n방의 모든 것이 삭제됩니다.(위치, 아이템)"),
					primaryButton: .destructive(Text("삭제"), action: {
						Task {
							await roomVM.removeRoom(roomId: removeRoomId)
							await roomVM.fetchRooms()
						}
					}),
					secondaryButton: .cancel(Text("취소"))
				)
			}
		}
		.task {
			await roomVM.fetchRooms()
		}
	}
}

#Preview {
	let roomVM = RoomViewModel()
	let itemVM = ItemViewModel()
	HomeListView().environmentObject(roomVM).environmentObject(itemVM)
}
