//
//  FavListView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI

struct FavListView: View {
	@EnvironmentObject var itemVM: ItemViewModel
	@Binding var showHeaderView: Bool
	let columns = [
		GridItem(.flexible(), spacing: 16),
		GridItem(.flexible(), spacing: 16)
	]
	var body: some View {
		NavigationSplitView {
			ScrollView {
				VStack(alignment: .leading) {
					Text("Fav List ✨")
						.font(.title)
						.bold()
						.onAppear {
							showHeaderView = true
						}
						.onAppear(perform: {
							itemVM.fetchFavItems(locationId: 1)
						}) 
						.padding(.top)
					LazyVGrid(columns: columns, spacing: 16) {
						ForEach(itemVM.favItems) { item in
							NavigationLink {
								ItemDetailView(item: item, showHeaderView: $showHeaderView)
							} label: {
								FavItemRow(item: item)
									.frame(height: 200)
							}
						}
					}
				}
				.padding()
				.offset(y: -30)
			}
			.background(Color.background)
		} detail: { Text("Select Your Fav Item") }
			
	}
}

//#Preview {
//	let itemVM = ItemViewModel()
//	FavListView().environmentObject(itemVM)
//}
