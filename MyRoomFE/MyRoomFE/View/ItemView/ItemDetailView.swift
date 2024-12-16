//
//  ItemDetailView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/19/24.
//

import SwiftUI

struct ItemDetailView: View {
	@Environment(\.dismiss) private var dismiss
	@EnvironmentObject var roomVM: RoomViewModel
	@EnvironmentObject var itemVM: ItemViewModel
	
	@State private var isShowingDeleteAlert: Bool = false
	@State private var isFav: Bool = false
	private var itemId: Int? // 아이템 ID
	private var initialItem: Item? // 직접 받은 아이템
	
	init(itemId: Int) { // itemId로 초기화
		self.itemId = itemId
	}
	
	init(item: Item) { // item 객체로 초기화
		self.initialItem = item
		isFav = item.isFav
	}
	
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(alignment: .leading, spacing: 18) {
					// item 선언
					if let item = initialItem ?? itemVM.items.first(where: { $0.id == itemId }) {
						itemImage(item: item)
						itemNameAndHeart(item: item)
						itemCreatedAtAndUpdatedAt(item: item)
						Divider()
						itemLocation(item: item)
						itemUrl(item: item)
						Divider()
						itemPriceAndColor(item: item)
						itemDesc(item: item)
						itemPurchaseAndExpiry(item: item)
						Divider()
						
						AdditionalPhotosView(itemPhotos: item.itemPhoto, itemId: item.id)
					} else {
						Text("아이템을 찾을 수 없습니다.")
							.foregroundColor(.red)
					}
					Spacer()
				}
				.padding()
			}
			
			.toolbar(content: {
				if let item = itemVM.items.first(where: {$0.id == itemId}){
					ToolbarItem(placement: .topBarTrailing) {
						Menu {
							NavigationLink("편집") {
								AddItemWithAIView(isEditMode: true, existingItem: item)
							}
							Button("삭제") {
								isShowingDeleteAlert = true
							}
							
						} label: {
							Image(systemName: "ellipsis")
						}
						.confirmationDialog(
							"\(item.itemName)을/를 삭제하시겠습니까?",
							isPresented: $isShowingDeleteAlert,
							titleVisibility: .visible
						) {
							Button("삭제", role: .destructive) {
								itemVM.removeItem(itemId: item.id)
								dismiss()
							}
						}
					}
				}
			})
			.alert("아이템 수정", isPresented: $itemVM.isShowingAlert, actions: {
				Button("확인", role: .cancel) {}
			}, message: {
				Text(itemVM.message)
			})
			.navigationTitle("아이템 상세 조회")
			.navigationBarTitleDisplayMode(.inline)
		}
	}
	
	
	private func itemImage(item: Item) -> some View {
		Group {
			if let photo = item.photo, !photo.isEmpty {
				AsyncImage(url: URL(string: photo.addingURLPrefix())) { image in
					image
						.resizable()
						.aspectRatio(3/4, contentMode: .fit)
						.frame(maxWidth: .infinity)
						.cornerRadius(10)
						.overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray).opacity(0.2))
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
		}
	}
	
	private func itemNameAndHeart(item: Item) -> some View {
		HStack {
			Text(item.itemName)
				.font(.title)
				.fontWeight(.bold)
				.lineLimit(1)
			Spacer()
			Button {
				itemVM.updateItemFav(itemId: item.id, itemFav: item.isFav)
				
			} label: {
				Image(systemName: item.isFav ? "heart.fill" : "heart")
					.renderingMode(.original)
					.font(.title)
					.foregroundStyle(item.isFav ? .red : .gray)
				
			}
		}
	}
	
	private func itemLocation(item: Item) -> some View {
		Label("위치  |  \(item.location?.room.roomName ?? "")의 \(item.location?.locationName ?? "")에 있습니다.", systemImage: "mappin.and.ellipse")
			.font(.headline)
	}
	
	private func itemPurchaseAndExpiry(item: Item) -> some View {
		HStack {
			if let purchaseDate = item.purchaseDate {
				Label("구매일: \(purchaseDate.dateToString())", systemImage: "calendar.badge.clock")
					.font(.subheadline)
			}
			Spacer()
			if let expiryDate = item.expiryDate {
				Label("유통기한: \(expiryDate.dateToString())", systemImage: "hourglass")
					.font(.subheadline)
					.foregroundColor(.red)
			}
		}
	}
	
	private func itemDesc(item: Item) -> some View {
		VStack(alignment: .leading) {
				Label("아이템 설명", systemImage: "tag.fill")
					.font(.subheadline)
					.foregroundColor(.primary)
				
			Text(item.desc ?? "아이템 설명을 입력해주세요.")
					.font(.system(size: 15))
					.padding()
					.frame(maxWidth: .infinity, alignment: .leading)
					.background {
						RoundedRectangle(cornerRadius: 10)
							.fill(Color.background)
					}
			}
		
		
	}
	
	private func itemPriceAndColor(item: Item) -> some View {
		HStack {
			if let price = item.price {
				Label("가격: \(price)원", systemImage: "tag.fill")
					.font(.subheadline)
					.foregroundColor(.green)
			} else {
				Label("가격: 가격을 입력해주세요.", systemImage: "tag.fill")
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
	}
	
	private func itemCreatedAtAndUpdatedAt(item: Item) -> some View {
		HStack {
			Text("아이템 생성일: \(item.createdAt.dateToString())")
				.font(.caption)
				.foregroundColor(.secondary)
			
			if item.createdAt != item.updatedAt {
				Text("(수정: \(item.updatedAt.dateToString()))")
					.font(.caption)
					.foregroundColor(.secondary)
			}
			Spacer()
		}
	}
	
	private func itemUrl(item: Item) -> some View {
		Group {
			if let strUrl = item.url, let url = URL(string: strUrl) {
				Link(destination: url) {
					Text("구매 링크로 가기")
						.foregroundStyle(.blue)
				}
			} else {
				if let url = URL(string: "https://msearch.shopping.naver.com/search/all?bt=-1&frm=NVSCPRO&query=\(item.itemName)") {
					Link(destination: url) {
						Text("등록한 URL이 없어요.\n네이버 가격비교로 가기")
							.foregroundStyle(.blue)
					}
				}
			}
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

