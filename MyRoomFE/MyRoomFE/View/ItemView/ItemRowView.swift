//
//  ItemRowView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/19/24.
//

import SwiftUI

struct ItemRowView: View {
	@EnvironmentObject var itemVM: ItemViewModel
	@State private var itemFav: Bool = false
	let item: Item
	var isSearch: Bool = false
	var body: some View {
		HStack {
			if let photo = item.photo {
				AsyncImage(url: URL(string: photo)) { image in
					image
						.resizable()
						.scaledToFill()
						.frame(width: 50, height: 50)
						.clipShape(RoundedRectangle(cornerRadius: 8))
				} placeholder: {
					ProgressView()
				}
			}
			VStack(alignment: .leading, spacing: 5) {
				Text(item.itemName)
					.font(.headline)
				if isSearch {
					Text("\(item.location.room.roomName)의 \(item.location.locationName)에 있습니다.")
				} else {
					if let desc = item.desc {
						Text(desc)
							.font(.subheadline)
							.foregroundColor(.secondary)
					}
				}
			}
			Spacer()
			Button {
				Task {
					await itemVM.updateItemFav(itemId: item.id, itemFav: item.isFav)
				}
			} label: {
				Image(systemName: "star.fill").foregroundStyle(item.isFav ? .yellow : .gray)
					.font(.system(size: 20))
			}
			.onAppear {
				itemFav = item.isFav
			}
		}
		.padding(.vertical, 8)
	}
}

//#Preview {
//	let itemVM = ItemViewModel()
//	ItemRowView(item: sampleItem).environmentObject(itemVM)
//}
