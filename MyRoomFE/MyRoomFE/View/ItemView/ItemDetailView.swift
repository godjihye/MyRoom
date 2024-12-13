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
	@State private var isFav: Bool
	
	var item: Item
	
	init(item: Item) {
		self.item = item
		self._isFav = State(initialValue: item.isFav) // State 초기화
	}
	
	var body: some View {
		NavigationStack {
			ScrollView{
				VStack(alignment: .leading, spacing: 18) {
					itemImage
					itemNameAndHeart
					itemCreatedAtAndUpdatedAt
					Divider()
					itemLocation
					itemUrl
					Divider()
					itemPriceAndColor
					itemDesc
					itemPurchaseAndExpiry
					Divider()
					
					AdditionalPhotosView(itemPhotos: item.itemPhoto, itemId: item.id)
					Spacer()
				}
				.padding()
			}
			.toolbar(content: {
				toolbarContent
			})
			.onAppear(perform: {
				itemVM.setCurrentItem(item: item)
			})
			.alert("좋아요", isPresented: $itemVM.isShowingAlert, actions: {
				Button("확인", role: .cancel){}
			}, message: {
				Text(itemVM.message)
			})
			.navigationTitle("아이템 상세 조회")
			.navigationBarTitleDisplayMode(.inline)
		}
	}
	
	private var itemImage: some View {
		Group {
			if let photo = item.photo, !photo.isEmpty {
				AsyncImage(url: URL(string: photo.addingURLPrefix())) { image in
					image
						.resizable()
						.aspectRatio(contentMode: .fill)
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
	
	private var itemNameAndHeart: some View {
		HStack {
			Text(item.itemName)
				.font(.title)
				.fontWeight(.bold)
				.lineLimit(1)
			Spacer()
			Button {
				isFav = !isFav
				Task {
					await itemVM.updateItemFav(itemId: item.id, itemFav: isFav)
					await itemVM.fetchItems(locationId: item.locationId)
				}
			} label: {
				Image(systemName: isFav ? "heart.fill" : "heart")
					.resizable()
					.frame(width: 30, height: 30)
					.foregroundStyle(isFav ? .red : .gray)
				
			}
		}
	}
	
	private var itemLocation: some View {
		Label("위치  |  \(item.location!.room.roomName)의 \(item.location!.locationName)에 있습니다.", systemImage: "mappin.and.ellipse")
			.font(.headline)
	}
	
	private var itemPurchaseAndExpiry: some View {
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
	
	private var itemDesc: some View {
		
		
		VStack(alignment: .leading) {
			if let desc = item.desc, !desc.isEmpty {
				Label("아이템 설명", systemImage: "tag.fill")
					.font(.subheadline)
					.foregroundColor(.primary)
				
				Text(desc)
					.font(.system(size: 15))
					.padding()
					.frame(maxWidth: .infinity, alignment: .leading)
					.background {
						RoundedRectangle(cornerRadius: 10)
							.fill(Color.background)
					}
			}
		}
		
	}
	
	private var itemPriceAndColor: some View {
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
	}
	
	private var itemCreatedAtAndUpdatedAt: some View {
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
	
	private var itemUrl: some View {
		Group {
			if let strUrl = item.url, let url = URL(string: strUrl) {
				Link(destination: url) {
					Text("구매 링크로 가기")
						.foregroundStyle(.blue)
				}
			} else {
				if let url = URL(string: "https://search.shopping.naver.com/search/all?bt=-1&frm=NVSCPRO&query=\(item.itemName)") {
					Link(destination: url) {
						Text("등록한 URL이 없어요.\n네이버 가격비교로 가기")
							.foregroundStyle(.blue)
					}
				}
			}
		}
	}
	private var toolbarContent: some ToolbarContent {
		Group {
			ToolbarItem(placement: .topBarTrailing) {
				Menu {
					NavigationLink("편집") {
						AddItemWithAIView(isEditMode: true, existingItem: item)
					}
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
				} label: {
					Image(systemName: "ellipsis")
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


#Preview {
	let itemVM = ItemViewModel()
	let roomVM = RoomViewModel()
	ItemDetailView(item: sampleItem).environmentObject(itemVM).environmentObject(roomVM)
}
