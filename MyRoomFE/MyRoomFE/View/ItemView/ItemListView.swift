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
	@State var isShowingAddItem: Bool = false
	@State var isShowingAddItemView: Bool = false
	@State var isShowingAddItemWithAIView: Bool = false
	@State var removeLocationId: Int = 0
	@State var isShowingAlert: Bool = false
	
	var location: Location
	var body: some View {
		NavigationStack {
			VStack {
				// 상단 Label, Button
				VStack{
					HStack {
						VStack(alignment: .leading) {
							Text(location.locationName)
								.font(.title)
								.bold()
							Text(location.locationDesc)
								.font(.caption)
						}
						NavigationLink {
							AddLocationView(locationName: location.locationName, locationDesc: location.locationDesc, selectedRoomId: location.roomId, title: "위치 정보 편집", rooms: roomVM.rooms) { roomId, locationName, locationDesc in
								Task {
									await roomVM.editLocation(locationId: location.id, locationName: locationName, locationDesc: locationDesc, roomId: roomId)}
							}
						} label: {
							Text("편집")
						}
						Button {
							Task {
								removeLocationId = location.id
								isShowingAlert = true
							}
						} label: {
							Text("삭제")
								.foregroundStyle(.red)
						}
						Spacer()
						Menu {
							// self.isShowingAddItem = true
							Button {
								isShowingAddItemView = true
							} label: {
								Text("직접 등록하기")
							}
							Button {
								isShowingAddItemWithAIView = true
							} label: {
								Text("AI로 등록하기")
							}

						} label: {
							Image(systemName: "plus")
								.font(.title2)
								.bold()
						}
					}
					.alert("위치 삭제 확인", isPresented: $isShowingAlert, actions: {
						Button("삭제", role: .destructive) {
							Task {
								await roomVM.removeLocation(locationId: removeLocationId)
								log("removeLocationId: \(removeLocationId)", trait: .info)
								await roomVM.fetchRooms()
							}
							dismiss()
						}
						Button("취소", role: .cancel) {
							log("위치 삭제 취소", trait: .info)
						}
					}, message: {
						Text("방 안의 아이템도 함께 삭제됩니다.")
					})
				}
				.padding(.horizontal)
				if !itemVM.items.isEmpty{
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
					Button("아이템이 없네요..."){
						isShowingAddItemView = true
					}
					.padding(.top, 200)
				}
				Spacer()
			}
			.frame(maxHeight: .infinity)
		 .background(Color.background)
		}
		.sheet(isPresented: $isShowingAddItemView) {
			AddItemView(locationId: location.id)
		}
		.sheet(isPresented: $isShowingAddItemWithAIView) {
			AddItemWithAIView(locationId: location.id)
		}
		.alert("즐겨찾기", isPresented: $itemVM.isShowingAlert, actions: {
			Button("확인", role: .cancel) {
				
			}
		})
		.task {
			await itemVM.fetchItems(locationId: location.id)
		}
	}
}

#Preview {
	let roomVM = RoomViewModel()
	let itemVM = ItemViewModel()
	ItemListView(isShowingAddItemView: false, location: sampleLocation).environmentObject(roomVM).environmentObject(itemVM)
}
