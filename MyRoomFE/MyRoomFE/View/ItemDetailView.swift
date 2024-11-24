//
//  ItemDetailView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/19/24.
//

import SwiftUI

import SwiftUI

struct ItemDetailView: View {
	@Environment(\.dismiss) private var dismiss
	
	let item: Item
	@EnvironmentObject var roomVM: RoomViewModel
	@EnvironmentObject var itemVM: ItemViewModel
	@State private var isShowingDeleteAlert: Bool = false
	@State private var selectedPhotoId: Int = 0
	@State private var isShowingDetailImageView: Bool = false
	@Binding var showHeaderView: Bool
	
	var body: some View {
		NavigationStack {
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
						.lineLimit(1)
					// Favorites
					Label("", systemImage: "heart.fill")
						.font(.subheadline)
						.foregroundColor(item.isFav ? .pink : .secondary)
						.onTapGesture {
							Task {
								await itemVM.updateItemFav(itemId: item.id, itemFav: item.isFav)
								await itemVM.fetchItems(locationId: item.locationId)
							}
						}
					Spacer()
					NavigationLink("편집") {
						AddItemView(isEditMode: true, existingItem: item)
					}
					.foregroundStyle(.gray)
					Button("삭제") {
						isShowingDeleteAlert = true
					}
					.confirmationDialog(
						"\(item.itemName)을/를 삭제하시겠습니까?",
						isPresented: $isShowingDeleteAlert,
						titleVisibility: .visible) {
							Button("삭제", role: .destructive) {
								Task {
									await itemVM.removeItem(itemId: item.id)
									dismiss()
								}
							}
						}
				}
				
				// Location
				Label("위치  |  \(item.locations.rooms.roomName)의 \(item.locations.locationName)에 있습니다.", systemImage: "mappin.and.ellipse")
					.font(.headline)
				
				// Purchase and Expiry Dates
				HStack {
					if let purchaseDate = item.purchaseDate {
						Label("구매일: \(dateToString(purchaseDate))", systemImage: "calendar.badge.clock")
							.font(.subheadline)
					}
					Spacer()
					if let expiryDate = item.expiryDate {
						Label("유통기한: \(dateToString(expiryDate))", systemImage: "hourglass")
							.font(.subheadline)
							.foregroundColor(.red)
					}
				}
				
				// Item Description
				if let desc = item.desc, !desc.isEmpty {
					VStack(alignment: .leading) {
						Label("아이템 설명", systemImage: "tag.fill")
							.font(.subheadline)
							.foregroundColor(.primary)
						Text(desc)
							.font(.body)
							.foregroundColor(.secondary)
							.padding(.top, 8)
					}
				}
				
				// Price and Color
				HStack {
					if let price = item.price {
						Label("가격: \(price)원", systemImage: "tag.fill")
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
				
				// Created and Updated At
				HStack {
					Text("Created At: \(dateToString(item.createdAt))")
						.font(.caption)
						.foregroundColor(.secondary)
					Spacer()
					Text("Updated At: \(dateToString(item.updatedAt))")
						.font(.caption)
						.foregroundColor(.secondary)
				}
				Label("추가 사진(사용설명서)", systemImage: "tag.fill")
					.font(.subheadline)
					.foregroundColor(.primary)
				if let photos = item.itemPhotos, !photos.isEmpty {
					ScrollView(.horizontal){
						HStack {
							ForEach(photos) { photo in
								AsyncImage(url: URL(string: photo.photo)) { image in
									image
										.resizable()
										.scaledToFit()
										.frame(maxWidth: .infinity, maxHeight: 400)
										.onTapGesture {
											selectedPhotoId = photo.id
											isShowingDetailImageView = true
										}
										.cornerRadius(10)
								} placeholder: {
									ProgressView()
								}
							}
						}
					}
				}
			}
			.padding()
			.navigationTitle("Item Details")
			.navigationBarTitleDisplayMode(.inline)
			.onAppear {
				showHeaderView = false
			}
			.fullScreenCover(isPresented: $isShowingDetailImageView) {
				if let itemPhotos = item.itemPhotos {
					ItemDetailImageView(selectedPhotoId: selectedPhotoId, itemPhotos: itemPhotos)
				}
			}
		}
		.background(Color.background)
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

#Preview {
	let itemVM = ItemViewModel()
	ItemDetailView(item: sampleItem, showHeaderView: .constant(false))
}
