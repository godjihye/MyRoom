//
//  AddItemView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/19/24.
//
//

import SwiftUI
import Foundation
import _PhotosUI_SwiftUI

struct AddItemView: View {
		@EnvironmentObject var itemVM: ItemViewModel
		@EnvironmentObject var roomVM: RoomViewModel
		@Environment(\.dismiss) private var dismiss

		@State private var itemName: String
		@State private var itemDesc: String
		@State private var itemPrice: String
		@State private var itemUrl: String
		@State private var purchaseDate: Date
		@State private var expiryDate: Date
		@State private var openDate: Date
		@State private var itemThumbnail: UIImage?
		@State private var isImagePickerPresented = false
		@State private var isPhotosPickerPresented = false
		@State private var selectedLocationId: Int
		@State private var itemColor: String
		@State private var additionalItems: [PhotosPickerItem] = []
		@State private var additionalPhotos: [UIImage] = []
		@State private var showAlert = false
		@State private var message = ""

		private let maxImageCount = 20
		let isEditMode: Bool
		let existingItem: Item?
		let locationId: Int

		init(
				isEditMode: Bool = false,
				existingItem: Item? = nil,
				locationId: Int = 0
		) {
				self.isEditMode = isEditMode
				self.existingItem = existingItem
				self.locationId = locationId

				_itemName = State(initialValue: existingItem?.itemName ?? "")
				_itemDesc = State(initialValue: existingItem?.desc ?? "")
				_itemPrice = State(initialValue: existingItem?.price.map { "\($0)" } ?? "")
				_itemUrl = State(initialValue: existingItem?.url ?? "")
				_purchaseDate = State(initialValue: stringToDate(existingItem?.purchaseDate))
				_expiryDate = State(initialValue: stringToDate(existingItem?.expiryDate))
				_openDate = State(initialValue: stringToDate(existingItem?.openDate))
				_selectedLocationId = State(initialValue: existingItem?.locationId ?? locationId)
				_itemColor = State(initialValue: existingItem?.color ?? "")
		}

		var body: some View {
				NavigationStack {
						Form {
								imageSection
								basicInfoSection
								additionalInfoSection
								additionalImagesSection
						}
						.navigationTitle(isEditMode ? "아이템 편집" : "새로운 아이템 추가")
						.toolbar { toolbarContent }
						.sheet(isPresented: $isImagePickerPresented) {
								ImagePicker(image: $itemThumbnail)
						}
						.task { await roomVM.fetchRooms() }
						.onAppear { loadInitialImages() }
						.onChange(of: additionalItems, { oldValue, newValue in handleAdditionalItemsChange() })
						.alert(message, isPresented: $showAlert) { Button("확인", role: .cancel) { } }
				}
		}

		// MARK: - Form Sections

		private var imageSection: some View {
				Section(header: Text("Image")) {
						Group {
								if let image = itemThumbnail {
										Image(uiImage: image)
												.resizable()
												.scaledToFit()
												.frame(height: 200)
												.cornerRadius(10)
								} else {
										Image(systemName: "photo")
												.resizable()
												.scaledToFit()
												.frame(height: 200)
												.cornerRadius(10)
								}
						}
						Button("이미지 선택 / 변경") {
								isImagePickerPresented = true
						}
				}
		}

		private var basicInfoSection: some View {
				Section(header: Text("기본 정보")) {
						TextField("아이템 이름", text: $itemName)
						TextField("아이템 설명", text: $itemDesc)
						Picker("아이템 위치", selection: $selectedLocationId) {
								ForEach(roomVM.locations) { location in
										Text(location.locationName).tag(location.id)
								}
						}
						.pickerStyle(MenuPickerStyle())
						TextField("Price", text: $itemPrice)
								.keyboardType(.decimalPad)
						TextField("URL", text: $itemUrl)
								.keyboardType(.URL)
				}
		}

		private var additionalInfoSection: some View {
				Section(header: Text("추가 정보")) {
						DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: .date)
						DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)
						DatePicker("Open Date", selection: $openDate, displayedComponents: .date)
				}
		}

		private var additionalImagesSection: some View {
			AddAdditionalPhotosView()
		}

		// MARK: - Toolbar

		private var toolbarContent: some ToolbarContent {
				ToolbarItemGroup(placement: .navigationBarTrailing) {
					Button("저장") { log("isSaveButtonDisabled:\(isSaveButtonDisabled)");saveItem() }
								.disabled(isSaveButtonDisabled) // true	이면 save disabled
				}
		}

		// MARK: - Helper Methods

		private func loadInitialImages() {
				if let strUrl = existingItem?.photo, let url = URL(string: strUrl.addingURLPrefix()) {
						Task {
								if let data = try? await URLSession.shared.data(from: url).0,
									 let uiImage = UIImage(data: data) {
										DispatchQueue.main.async { itemThumbnail = uiImage }
								}
						}
				}

				if let strUrls = existingItem?.itemPhoto {
						Task {
								for strUrl in strUrls {
										if let url = URL(string: strUrl.photo.addingURLPrefix()),
											 let data = try? await URLSession.shared.data(from: url).0,
											 let uiImage = UIImage(data: data) {
												DispatchQueue.main.async { additionalPhotos.append(uiImage) }
										}
								}
						}
				}
		}

		private func handleAdditionalItemsChange() {
				Task {
						additionalPhotos = []
						for item in additionalItems {
								if let data = try? await item.loadTransferable(type: Data.self),
									 let uiImage = UIImage(data: data) {
										additionalPhotos.append(uiImage)
								}
						}
				}
		}

		private func saveItem() {
				Task {
						if isEditMode, let item = existingItem {
								await itemVM.editItem(
										itemId: item.id,
										itemName: itemName,
										purchaseDate: purchaseDate.description,
										expiryDate: expiryDate.description,
										itemUrl: itemUrl,
										image: itemThumbnail,
										desc: itemDesc,
										color: itemColor,
										price: Int(itemPrice) ?? 0,
										openDate: openDate.description,
										locationId: selectedLocationId
								)
								await itemVM.addAdditionalPhotos(images: additionalPhotos, itemId: item.id)
						} else {
								let newItem = try? await itemVM.addItem(
										itemName: itemName,
										purchaseDate: purchaseDate.description,
										expiryDate: expiryDate.description,
										itemUrl: itemUrl,
										image: itemThumbnail,
										desc: itemDesc,
										color: itemColor,
										price: Int(itemPrice) ?? 0,
										openDate: openDate.description,
										locationId: selectedLocationId
								)
								if let newId = newItem?.documents.first?.id {
										await itemVM.addAdditionalPhotos(images: additionalPhotos, itemId: newId)
								}
						}
						await itemVM.fetchItems(locationId: selectedLocationId)
						dismiss()
				}
		}

	private var isSaveButtonDisabled: Bool {
			guard let existingItem = existingItem else { return true }
			
			let isUnchanged = itemName == existingItem.itemName &&
					itemDesc == existingItem.desc &&
					Int(itemPrice) == existingItem.price &&
					itemUrl == existingItem.url ?? "" &&
					areDatesEqual(purchaseDate, stringToDate(existingItem.purchaseDate)) &&
					areDatesEqual(expiryDate, stringToDate(existingItem.expiryDate)) &&
					areDatesEqual(openDate, stringToDate(existingItem.openDate)) &&
					selectedLocationId == existingItem.locationId &&
					itemColor == existingItem.color
			return isEditMode ? isUnchanged : itemName.isEmpty || selectedLocationId == 0
	}

	private func areDatesEqual(_ date1: Date, _ date2: Date) -> Bool {
			let calendar = Calendar.current
			return calendar.isDate(date1, equalTo: date2, toGranularity: .day)
	}


}

#Preview {
		AddItemView().environmentObject(RoomViewModel())
}
