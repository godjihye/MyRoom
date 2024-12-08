//
//  ItemListView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI

struct ItemListView: View {
		@Environment(\.dismiss) private var dismiss
		@EnvironmentObject var roomVM: RoomViewModel
		@EnvironmentObject var itemVM: ItemViewModel
		
		@State private var isShowingAddItemWithAIView = false
		@State private var removeLocationId: Int = 0
		@State private var isShowingAlert = false
		
		var location: Location
		
		var body: some View {
				NavigationStack {
						VStack {
								headerView
								itemListView
								Spacer()
						}
						.frame(maxHeight: .infinity)
						.background(Color.background)
						.task {
								await itemVM.fetchItems(locationId: location.id)
						}
						.alert("위치 삭제 확인", isPresented: $isShowingAlert, actions: {
								alertActions
						}, message: {
								Text("방 안의 아이템도 함께 삭제됩니다.")
						})
						.sheet(isPresented: $isShowingAddItemWithAIView) {
								AddItemWithAIView(locationId: location.id)
						}
				}
		}
		
		private var headerView: some View {
				VStack {
						HStack {
								locationInfo
								Spacer()
								addItemButton
						}
						.padding(.horizontal)
				}
		}
		
		private var locationInfo: some View {
				VStack(alignment: .leading) {
						Text(location.locationName)
								.font(.title)
								.bold()
						Text(location.locationDesc)
								.font(.caption)
				}
		}
		
		private var addItemButton: some View {
				HStack(spacing: 20) {
						editButton
						deleteButton
						addItemWithAIButton
				}
		}
		
		private var editButton: some View {
				NavigationLink {
						AddLocationView(
								locationName: location.locationName,
								locationDesc: location.locationDesc,
								selectedRoomId: location.roomId,
								title: "위치 정보 편집",
								rooms: roomVM.rooms
						) { roomId, locationName, locationDesc in
								Task {
										await roomVM.editLocation(locationId: location.id, locationName: locationName, locationDesc: locationDesc, roomId: roomId)
								}
						}
				} label: {
						Text("편집")
				}
		}
		
		private var deleteButton: some View {
				Button {
						removeLocationId = location.id
						isShowingAlert = true
				} label: {
						Text("삭제")
								.foregroundStyle(.red)
				}
		}
		
		private var addItemWithAIButton: some View {
				Button {
						isShowingAddItemWithAIView = true
				} label: {
						Image(systemName: "plus")
								.font(.title2)
								.bold()
				}
		}
		
		private var itemListView: some View {
				Group {
						if !itemVM.items.isEmpty {
								List(itemVM.items) { item in
										NavigationLink {
												ItemDetailView(item: item)
										} label: {
												ItemRowView(item: item)
										}
								}
								.listStyle(.inset)
								.refreshable {
										await itemVM.fetchItems(locationId: location.id)
								}
						} else {
								noItemsView
						}
				}
		}
		
		private var noItemsView: some View {
				Button("아이템이 없네요...") {
						// 아이템 추가 화면 띄우기
				}
				.padding(.top, 200)
		}
		
		private var alertActions: some View {
				Group {
						Button("삭제", role: .destructive) {
								Task {
										await roomVM.removeLocation(locationId: removeLocationId)
										await roomVM.fetchRooms()
										dismiss()
								}
						}
						
						Button("취소", role: .cancel) {
								log("위치 삭제 취소", trait: .info)
						}
				}
		}
}

#Preview {
		let roomVM = RoomViewModel()
		let itemVM = ItemViewModel()
		ItemListView(location: sampleLocation)
				.environmentObject(roomVM)
				.environmentObject(itemVM)
}
