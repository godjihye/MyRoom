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
	@State private var removeRoomCheck: Bool = false
	@State private var isShowingAlertRemove: Bool = false
	
	@Binding var showHeaderView: Bool
	
	var body: some View {
		NavigationStack {
			VStack(alignment: .leading) {
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
				.padding(.horizontal)
				List {
					ForEach(roomVM.rooms) { (room: Room) in
						Section(header: HStack {
							Text(room.roomName)
							Spacer()
							NavigationLink("편집") {
								AddRoomView(title: "방 정보 편집", roomName: room.roomName, roomDesc: room.roomDesc) { roomName, roomDesc in
									roomVM.editRoom(roomId: room.id, roomName: roomName, roomDesc: roomDesc)
									roomVM.fetchRooms()
								}
							}
							.font(.system(size: 15))
							.foregroundStyle(.secondary)
							Button("삭제") {
								isShowingAlert = true
								if removeRoomCheck {
									roomVM.removeRoom(roomId: room.id)
									roomVM.fetchRooms()
								}
							}
							.font(.system(size: 15))
							.foregroundStyle(.red)
						}) {
							ForEach(room.Locations) { (location: Location) in
								NavigationLink(destination: ItemListView(showHeaderView: $showHeaderView, location: location).environmentObject(ItemViewModel())) {
									Text(location.locationName)
										.padding(8)
								}
							}
						}
					}
					.sheet(isPresented: $isShowingAddRoomView) {
						AddRoomView {roomName, roomDesc in
							roomVM.addRoom(roomName: roomName, roomDesc: roomDesc)
						}
					}
					.sheet(isPresented: $isShowingAddLocationView) {
						AddLocationView(rooms: roomVM.rooms) { roomId, locationName, locationDesc in
							roomVM.addLocation(locationName: locationName, locationDesc: locationDesc, roomId: roomId)
						}
					}
					.refreshable {
						roomVM.fetchRooms()
					}
				}
			}
			.background(Color.background)
			.onAppear {
				showHeaderView = true
				roomVM.fetchRooms()
			}
			.alert(isPresented: $isShowingAlert) {
				Alert(
					title: Text("방 삭제 확인"),
					message: Text("정말로 방을 삭제하시겠습니까?"),
					primaryButton: .destructive(Text("삭제"), action: {
						removeRoomCheck = true
					}),
					secondaryButton: .cancel(Text("취소"))
				)
			}
		}
	}
}

#Preview {
	let roomVM = RoomViewModel()
	let itemVM = ItemViewModel()
	HomeListView(showHeaderView: .constant(true)).environmentObject(roomVM).environmentObject(itemVM)
}
