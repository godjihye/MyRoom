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
	
	var body: some View {
		NavigationStack {
			
			VStack(alignment: .leading) {
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
						Section(header: Text(room.roomName)){
							ForEach(room.Locations) { (location: Location) in
								NavigationLink(destination: ItemListView(location: location)) {
									Text(location.locationName)
										.padding(8)
								}
							}
						}
					}
				}
				.sheet(isPresented: $isShowingAddRoomView) {
					AddRoomView { roomName, roomDesc in
						Task{
							await roomVM.addRoom(roomName: roomName, roomDesc: roomDesc)
						}
					}
				}
				.sheet(isPresented: $isShowingAddLocationView) {
					AddLocationView(rooms: roomVM.rooms) { roomId, locationName, locationDesc in
						Task {
							await roomVM.addLocation(locationName: locationName, locationDesc: locationDesc, roomId: roomId)
						}
					}
				}
				.refreshable {
					await roomVM.fetchRooms()
				}
			}
			.background(Color.backgroud)
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