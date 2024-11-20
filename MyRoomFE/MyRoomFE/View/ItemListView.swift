//
//  ItemListView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI
let sampleLocation = Location(id: 1, locationName: "책장", locationDesc: "책상 옆 책장")
struct ItemListView: View {
	@EnvironmentObject var roomVM: RoomViewModel
	@EnvironmentObject var itemVM: ItemViewModel
	@State var isShowingAddItemView: Bool = false
	@Binding var showHeaderView: Bool
	var location: Location
	var body: some View {
		NavigationView {
			VStack {
				// 상단 Label, Button
				HStack {
					Text(location.locationName)
						.font(.title)
						.bold()
					Button("삭제") {
						roomVM.removeLocation(locationId: location.id)
					}.foregroundStyle(.red)

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
						NavigationLink(destination: ItemDetailView(item: item)) {
							ItemRowView(item: item)
						}
					}
					.listStyle(.inset)
				} else {
					Button("아이템이 없네요..."){
						isShowingAddItemView = true
					}
				}
			}
			.background(Color.background)
		}
		.sheet(isPresented: $isShowingAddItemView) {
			AddItemView(locations: roomVM.locations) 
		}
		.onAppear {
			itemVM.fetchItems(locationId: location.id)
		}
	}
}

#Preview {
	let itemVM = ItemViewModel()
	let roomVM = RoomViewModel()
	ItemListView(showHeaderView: .constant(false), location: sampleLocation).environmentObject(itemVM).environmentObject(roomVM)
}

