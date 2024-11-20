//
//  ItemDetailView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/19/24.
//

import SwiftUI

import SwiftUI

struct ItemDetailView: View {
	let item: Item
	@EnvironmentObject var itemVM: ItemViewModel
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {
				// Item Image
				if let photo = item.photo, !photo.isEmpty {
					AsyncImage(url: URL(string: photo)) { image in
						image
							.resizable()
							.scaledToFit()
							.frame(maxWidth: .infinity)
							.cornerRadius(10)
					} placeholder: {
						ProgressView()
					}
				} else {
					Image(systemName: "photo.fill")
						.resizable()
						.scaledToFit()
						.frame(maxWidth: .infinity)
						.foregroundColor(.gray)
						.opacity(0.5)
						.cornerRadius(10)
				}
				
				// Item Name
				HStack {
					Text(item.itemName)
						.font(.title)
						.fontWeight(.bold)
					Button("삭제") {
						itemVM.deleteItem(itemId: item.id)
					}
				}
				
				// Purchase and Expiry Dates
				HStack {
					if let purchaseDate = item.purchaseDate {
						Label("Purchased: \(purchaseDate)", systemImage: "calendar.badge.clock")
							.font(.subheadline)
					}
					Spacer()
					if let expiryDate = item.expiryDate {
						Label("Expires: \(expiryDate)", systemImage: "hourglass")
							.font(.subheadline)
							.foregroundColor(.red)
					}
				}
				
				// Item Description
				if let desc = item.desc, !desc.isEmpty {
					Text(desc)
						.font(.body)
						.foregroundColor(.secondary)
						.padding(.top, 8)
				}
				
				// Price and Color
				HStack {
					if let price = item.price {
						Label("Price: $\(price)", systemImage: "tag.fill")
							.font(.subheadline)
							.foregroundColor(.green)
					}
					Spacer()
					if let color = item.color, !color.isEmpty {
						HStack {
							Text("Color:")
							Circle()
								.fill(Color(hex: color))
								.frame(width: 20, height: 20)
						}
						.font(.subheadline)
					}
				}
				
				// Location
//				if let locationId = item.locationId {
//					Label("Location ID: \(locationId)", systemImage: "mappin.and.ellipse")
//						.font(.subheadline)
//				}
				
				// Favorites
				if item.isFav {
					Label("Favorite", systemImage: "heart.fill")
						.font(.subheadline)
						.foregroundColor(.pink)
				}
				
				// Created and Updated At
				if let createdAt = item.createdAt {
					Text("Created At: \(createdAt)")
						.font(.caption)
						.foregroundColor(.secondary)
				}
				if let updatedAt = item.updatedAt {
					Text("Updated At: \(updatedAt)")
						.font(.caption)
						.foregroundColor(.secondary)
				}
			}
			.padding()
			.navigationTitle("Item Details")
			.navigationBarTitleDisplayMode(.inline)
		}
	}
}

// Helper: Convert HEX Color to SwiftUI Color
extension Color {
	init(hex: String) {
		let scanner = Scanner(string: hex)
		scanner.currentIndex = hex.startIndex
		var rgbValue: UInt64 = 0
		scanner.scanHexInt64(&rgbValue)
		
		let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
		let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
		let blue = Double(rgbValue & 0x0000FF) / 255.0
		self.init(red: red, green: green, blue: blue)
	}
}
//
//#Preview {
//	ItemDetailView(item: sample)
//}
