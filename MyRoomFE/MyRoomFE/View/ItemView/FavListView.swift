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
		GridItem(.flexible(), spacing: 10),
		GridItem(.flexible(), spacing: 10)
	]
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack {
					HStack {
						Text("Fav List ✨")
							.font(.title)
							.bold()
							.padding(.top)
						Spacer()
//						Button {
//						} label: {
//							Image(systemName: "plus")
//								.font(.title)
//								.bold()
//						}
					}
					.padding(.horizontal)
					
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
					} else { Text("Fav에 추가된 아이템이 없습니다.")
						.padding(.top, 250)}
				}
			}
			.frame(maxWidth: .infinity)
			.background(Color.background)
			.task {
				if itemVM.favItems.isEmpty {
					await itemVM.fetchFavItems()
				}
			}
		}
	}
}

#Preview {
	let itemVM = ItemViewModel()
	FavListView().environmentObject(itemVM)
}