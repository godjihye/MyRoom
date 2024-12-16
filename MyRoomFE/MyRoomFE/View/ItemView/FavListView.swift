//
//  FavListView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI

struct FavListView: View {
	@EnvironmentObject var itemVM: ItemViewModel
	
	let columns = [
		GridItem(.flexible()),
		GridItem(.flexible())
	]
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack {
					//titleView
					list
				}
			}
			.frame(maxWidth: .infinity)
			.task {
				await itemVM.fetchFavItems()
			}
		}
	}
	
	
	private var list: some View {
		Group {
			if !itemVM.favItems.isEmpty {
				LazyVGrid(columns: columns, spacing: 16) {
					ForEach(itemVM.favItems) { item in
						if item.isFav {
							NavigationLink {
								ItemDetailView(item: item)
							} label: {
								FavItemRow(item: item)
							}
						}
					}
				}
				.padding(.top)
				.padding(.horizontal)
			} else {
				Text("Fav에 추가된 아이템이 없습니다.")
					.padding(.top, 250)
			}
		}
	}
}

#Preview {
	let itemVM = ItemViewModel()
	FavListView().environmentObject(itemVM)
}
