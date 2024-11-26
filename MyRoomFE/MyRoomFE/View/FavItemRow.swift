//
//  FavItemRow.swift
//  MyRoomFE
//
//  Created by jhshin on 11/19/24.
//

import SwiftUI
import Foundation

struct FavItemRow: View {
	let item: Item
	var dateFormatter = DateFormatter()
	
	var body: some View {
		VStack {
			if let photo = item.photo, let itemPhotoUrl = URL(string: photo) {
				AsyncImage(url: itemPhotoUrl) { image in
					image.image?.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: 160, height: 160)
						.clipShape(RoundedRectangle(cornerRadius: 10))
				}
			}
			Text(item.itemName)
				.bold()
			Text(item.purchaseDate?.split(separator: "T")[0] ?? "")
				.foregroundStyle(.secondary)
		}
		.foregroundStyle(.black)
		.frame(maxWidth: .infinity)
		.aspectRatio(1, contentMode: .fit)
	}
}

#Preview {
	FavItemRow(item: sampleItem)
}
