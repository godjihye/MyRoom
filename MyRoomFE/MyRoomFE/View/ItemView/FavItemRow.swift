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
			itemImage
			Text(item.itemName)
				.bold()
			Text(item.purchaseDate?.split(separator: "T")[0] ?? "")
				.foregroundStyle(.secondary)
		}
		.foregroundStyle(.black)
		.frame(maxWidth: .infinity)
		.aspectRatio(1, contentMode: .fit)
	}
	private var itemImage: some View {
		Group {
			if let photo = item.photo, let itemPhotoUrl = URL(string: photo.addingURLPrefix()) {
				AsyncImage(url: itemPhotoUrl) { image in
					image.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: 180, height: 180)
						.clipShape(RoundedRectangle(cornerRadius: 10))
				} placeholder: {
					ProgressView()
				}
			}
		}
	}
}

#Preview {
	FavItemRow(item: sampleItem)
}
