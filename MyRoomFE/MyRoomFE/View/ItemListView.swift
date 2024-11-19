//
//  ItemListView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI
let sampleLocation = Location(id: 1, locationName: "책장", locationDesc: "책상 옆 책장")
struct ItemListView: View {
	@EnvironmentObject var itemVM: ItemViewModel
	@State var isShowingAddRoomView: Bool = false
	@Binding var showHeaderView: Bool
	var location: Location
	var body: some View {
		NavigationView {
			if !itemVM.items.isEmpty{
				List(itemVM.items) { item in
					NavigationLink(destination: ItemDetailView(showHeaderView: $showHeaderView, item: item)) {
						ItemRowView(item: item)
					}
				}
				.navigationTitle(location.locationName)
				.toolbar {
					ToolbarItem(placement: .topBarTrailing) {
						Button {
							self.isShowingAddRoomView = true
						} label: {
							Image(systemName: "plus")
								.font(.system(size: 20))
								.bold()
						}
						
					}
				}
				.sheet(isPresented: $isShowingAddRoomView) {
					Text("")
				}
			} else {
				Text("아이템이 없네요...")
				Button("아이템 추가하기") {
					
				}
			}
				
			
			
		}
		
		.listStyle(InsetGroupedListStyle())
		.onAppear {
				showHeaderView = false
		}
		.task {
			showHeaderView = false
			await itemVM.fetchItems(locationId: location.id) // 데이터 가져오기
		}
	}
}

#Preview {
	let itemVM = ItemViewModel()
	ItemListView(showHeaderView: .constant(false), location: sampleLocation).environmentObject(itemVM)
}

