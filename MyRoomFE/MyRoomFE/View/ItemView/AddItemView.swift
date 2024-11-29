//
//  AddItemView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/19/24.
//

import SwiftUI
import Foundation

struct AddItemView: View {
	@EnvironmentObject var itemVM: ItemViewModel
	@EnvironmentObject var roomVM: RoomViewModel
	@Environment(\.dismiss) private var dismiss
	
	@State private var itemName: String
	@State private var itemDesc: String
	@State private var itemLocation: String
	@State private var itemPrice: String
	@State private var itemUrl: String
	@State private var purchaseDate: Date
	@State private var expiryDate: Date
	@State private var openDate: Date
	@State private var selectedImage: [UIImage] = []
	@State private var isImagePickerPresented: Bool = false
	@State var selectedLocationId: Int = 0
	@State private var itemColor: String
	@State private var additionalPhotos: [UIImage] = []
	@State private var isPickOneImage: Bool = true
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
		_itemLocation = State(initialValue: "")
		_itemPrice = State(initialValue: existingItem?.price.map { "\($0)" } ?? "")
		_itemUrl = State(initialValue: existingItem?.url ?? "")
		// 초기값 수정
		_purchaseDate = State(initialValue: stringToDate(existingItem?.purchaseDate))
		_expiryDate = State(initialValue: stringToDate(existingItem?.expiryDate))
		_openDate = State(initialValue: stringToDate(existingItem?.openDate))
		_selectedLocationId = State(initialValue: existingItem?.locationId ?? locationId)
		_itemColor = State(initialValue: existingItem?.color ?? "")
		//_additionalPhotos = State(initialValue: existingItem?.itemPhotos )
	}
	
	var body: some View {
		NavigationStack {
			Form {
				Section(header: Text("Image")) {
					if let image = selectedImage.first {
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
					Button("이미지 선택 / 변경") {
						isPickOneImage = true
						isImagePickerPresented = true
					}
				}
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
				
				Section(header: Text("추가 정보")) {
					DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: .date)
					DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)
					DatePicker("Open Date", selection: $openDate, displayedComponents: .date)
				}
				
				Section(header: Text("추가 이미지 정보")) {
					ScrollView(.horizontal) {
						ForEach(additionalPhotos, id: \.self) { photo in
							Image(uiImage: photo)
								.resizable()
								.scaledToFit()
								.frame(width: 100, height: 100)
								.cornerRadius(10)
						}
					}
					Button("추가 이미지 선택") {
						isPickOneImage = false
						isImagePickerPresented = true
						
							log("isPickOneImage: \(isPickOneImage), isImagePickerPresented: \(isImagePickerPresented)", trait: .info)
					}
				}
			}
			.navigationTitle(isEditMode ? "아이템 편집" : "새로운 아이템 추가")
			
			.toolbar {
				ToolbarItem(placement: .confirmationAction) {
					Button("Save") {
						if isEditMode, let item = existingItem {
							Task {
								await itemVM.editItem(itemId: item.id, itemName: itemName, purchaseDate: purchaseDate.description, expiryDate: expiryDate.description, itemUrl: itemUrl, image: "", desc: itemDesc, color: itemColor, price: Int(itemPrice) ?? 0, openDate: openDate.description, locationId: selectedLocationId)
								await itemVM.fetchItems(locationId: selectedLocationId)
								dismiss()
							}
						} else {
							Task {
								await itemVM.addItem(itemName: itemName, purchaseDate: purchaseDate.description, expiryDate: expiryDate.description, itemUrl: itemUrl, image: selectedImage.first, desc: itemDesc, color: itemColor, price: Int(itemPrice) ?? 0, openDate: openDate.description, locationId: selectedLocationId)
								await itemVM.fetchItems(locationId: selectedLocationId)
								dismiss()
							}
						}
					}
					
					.disabled(itemName.isEmpty)
				}
				if !isEditMode{
					ToolbarItem(placement: .cancellationAction) {
						Button("Cancel") {
							dismiss()
						}
					}
				}
			}
		}
		.sheet(isPresented: $isImagePickerPresented) {
			if isPickOneImage {
				//ImagePicker(selectedImages: $selectedImage, selectionLimit: 1)
			} else {
				//ImagePicker(selectedImages: $additionalPhotos, selectionLimit: 20)
			}
		}
		.sheet(isPresented: $isImagePickerPresented) {
			
		}
		.task {
			await roomVM.fetchRooms()
		}
		.onAppear {
			loadInitialImage()
		}
	}
	func loadInitialImage() {
		if let strUrl = existingItem?.photo, let url = URL(string: strUrl) {
			Task {
				do {
					let (data, _) = try await URLSession.shared.data(from: url)
					if let uiImage = UIImage(data: data) {
						DispatchQueue.main.async {
							self.selectedImage = [uiImage]
						}
					}
				} catch {
					print("Error loading image: \(error)")
				}
			}
		}
		if let strUrls = existingItem?.itemPhotos {
			var urls: [URL] = []
			for strUrl in strUrls {
				if let url = URL(string: strUrl.photo) {
					urls.append(url)
				}
			}
		}
	}
}




#Preview {
	let roomVM = RoomViewModel()
	AddItemView().environmentObject(roomVM)
}
