//
//  ItemListView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI

struct ItemListView: View {
	@EnvironmentObject var roomVM: RoomViewModel
	@EnvironmentObject var itemVM: ItemViewModel
	@State var isShowingAddItemView: Bool = false
	@Binding var showHeaderView: Bool

	var location: Location
	var body: some View {
		NavigationStack {
			VStack {
				// 상단 Label, Button
				HStack {
					Text(location.locationName)
						.font(.title)
						.bold()
					NavigationLink {
						AddLocationView(locationName: location.locationName, locationDesc: location.locationDesc, selectedRoomId: location.roomId, title: "위치 정보 편집", rooms: roomVM.rooms) { roomId, locationName, locationDesc in
							Task {
								await roomVM.editLocation(locationId: location.id, locationName: locationName, locationDesc: locationDesc, roomId: roomId)}
						}
					} label: {
						Text("편집")
					}

					Button("삭제") {
						Task {
							await roomVM.removeLocation(locationId: location.id)}
					}
					.foregroundStyle(.red)

					Spacer()
					Button {
						self.isShowingAddItemView = true
					} label: {
						Image(systemName: "plus")
							.font(.title2)
							.bold()
					}
				}
				.padding(.horizontal)
				.offset(y: 0)
				// 아이템 리스트
				if !itemVM.items.isEmpty{
					List(itemVM.items) { item in
						NavigationLink {
							ItemDetailView(item: item, showHeaderView: $showHeaderView)
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
			AddItemView()
		}
		.alert("즐겨찾기", isPresented: $itemVM.isShowingAlert, actions: {
			Button("확인", role: .cancel) {
				
			}
		})
		.task {
			await itemVM.fetchItems(locationId: location.id)
		}
		.onDisappear {
			showHeaderView = false
		}
	
		}

}

