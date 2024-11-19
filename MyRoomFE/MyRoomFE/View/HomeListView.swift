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
	@Binding var showHeaderView: Bool
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
								NavigationLink(
									destination: ItemListView(
										showHeaderView: $showHeaderView,
										location: location
									)
								) {
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
							addRoom(roomName: roomName, roomDesc: roomDesc)
						}
					}
				}
				.sheet(isPresented: $isShowingAddLocationView) {
					AddLocationView(rooms: roomVM.rooms) { roomId, locationName, locationDesc in
						addLocation(locationName: locationName, locationDesc: locationDesc, roomId: roomId)
					}
				}
				.refreshable {
					fetchRooms()
				}
			}
			.background(Color.backgroud)
		}
		.onAppear {
			showHeaderView = true
		}
		.task {
			await roomVM.fetchRooms()
		}
	}
	private func fetchRooms() {
			Task {
					await roomVM.fetchRooms()
			}
	}

	private func addRoom(roomName: String, roomDesc: String) {
			Task {
					await roomVM.addRoom(roomName: roomName, roomDesc: roomDesc)
					await roomVM.fetchRooms()
			}
	}

	private func addLocation(locationName: String, locationDesc: String, roomId: Int) {
			Task {
					await roomVM.addLocation(locationName: locationName, locationDesc: locationDesc, roomId: roomId)
					await roomVM.fetchRooms()
			}
	}

}

//#Preview {
//	let roomVM = RoomViewModel()
//	let itemVM = ItemViewModel()
//	HomeListView().environmentObject(roomVM).environmentObject(itemVM)
//}
