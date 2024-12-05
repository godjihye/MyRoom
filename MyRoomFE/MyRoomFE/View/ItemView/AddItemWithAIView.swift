//
//  AddItemWithAIView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/4/24.
//

import SwiftUI
import Foundation
import _PhotosUI_SwiftUI
import Vision

struct AddItemWithAIView: View {
	@EnvironmentObject var itemVM: ItemViewModel
	@EnvironmentObject var roomVM: RoomViewModel
	@Environment(\.dismiss) private var dismiss
	
	// Item 기본 정보
	@State private var itemName: String
	@State private var itemThumbnail: UIImage?
	
	// Item 추가 정보
	@State private var itemDesc: String
	@State private var itemPrice: String
	@State private var itemUrl: String
	@State private var purchaseDate: Date
	@State private var expiryDate: Date
	@State private var openDate: Date
	@State private var selectedLocationId: Int
	@State private var itemColor: String
	
	@State private var additionalItems: [PhotosPickerItem] = []
	@State private var additionalPhotos: [UIImage] = []
	
	@State private var showAlert = false
	@State private var message = ""
	
	@State private var isShowingImageSource: Bool = false
	@State private var showImagePicker: Bool = false
	@State private var isPhotosPickerPresented: Bool = false
	@State private var isCamera: Bool = false
	
	@State private var isVisionRecog: Bool = false
	@State private var recognizedText: [String] = []
	
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
				//additionalImagesSection
			}
			.navigationTitle(isEditMode ? "아이템 편집" : "새로운 아이템 추가")
			.toolbar { toolbarContent }
			.sheet(isPresented: $showImagePicker) {
				if isCamera {
					CameraPicker(image: $itemThumbnail, sourceType: .camera)
				} else {
					ImagePicker(image: $itemThumbnail)
				}
			}
			.task { await roomVM.fetchRooms() }
			.onAppear { loadInitialImages() }
			.onChange(of: itemThumbnail ?? UIImage(), { oldValue, newValue in
				recognizeText(from: newValue)
			})
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
			Button("사진 선택 / 변경") {
				isShowingImageSource = true
			}
			.confirmationDialog("사진 소스 선택", isPresented: $isShowingImageSource, titleVisibility: .visible) {
				Button("포토 앨범") {
					isCamera = false
					showImagePicker = true
				}
				Button("카메라") {
					isCamera = true
					showImagePicker = true
				}
			}
		}
	}
	
	private var basicInfoSection: some View {
		Section(header: Text("기본 정보")) {
			TextField("아이템 이름", text: $itemName)
			if !recognizedText.isEmpty {
				ScrollView(.horizontal) {
					HStack {
						Text("추천: ")
						ForEach(recognizedText, id: \.self) { text in
							Button {
								itemName = text
							} label: {
								Text(text)
									.padding(.all, 8)
									.overlay(RoundedRectangle(cornerRadius: 20).stroke(.gray))
							}
						}
					}
				}
			}
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
	
//	private var additionalImagesSection: some View {
//		AddAdditionalPhotosView()
//	}
	
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
				let newItem = try? await itemVM.addItem(
					itemName: itemName,
					purchaseDate: purchaseDate.description,
					expiryDate: expiryDate.description,
					itemUrl: itemUrl,
					image: itemThumbnail,
					desc: itemDesc,
					color: itemColor,
					price: Int(itemPrice),
					openDate: openDate.description,
					locationId: selectedLocationId
				)
//			await itemVM.fetchItems(locationId: selectedLocationId)
			dismiss()
		}
	}
	
	private var isSaveButtonDisabled: Bool {
		itemName.isEmpty || selectedLocationId == 0
	}
	
	private func areDatesEqual(_ date1: Date, _ date2: Date) -> Bool {
		let calendar = Calendar.current
		return calendar.isDate(date1, equalTo: date2, toGranularity: .day)
	}
	
	private func recognizeText(from image: UIImage) {
		guard let cgImage = image.cgImage else {
			recognizedText.append("Could not load image.")
			return
		}
		
		let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
		let request = VNRecognizeTextRequest { request, error in
			guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
				recognizedText.append("Text recognition failed.")
				return
			}
			
			let text = observations.compactMap {
				$0.topCandidates(1).first?.string
			}
			
			DispatchQueue.main.async {
				recognizedText = text
			}
		}
		
		if #available(iOS 16.0, *) {
			request.revision = VNRecognizeTextRequestRevision3
			request.recognitionLevel = .accurate
			request.recognitionLanguages = ["ko-KR"]
			request.usesLanguageCorrection = true
			
			do {
				let supportedLanguages = try request.supportedRecognitionLanguages()
				print("Supported languages: \(supportedLanguages)")
			} catch {
				print("Error fetching supported languages: \(error)")
			}
		} else {
			request.recognitionLanguages = ["en-US"]
			request.usesLanguageCorrection = true
		}
		do {
			try handler.perform([request])
		} catch {
			DispatchQueue.main.async {
				recognizedText.append("Error: \(error.localizedDescription)")
			}
		}
	}
	
}

#Preview {
	AddItemWithAIView().environmentObject(RoomViewModel())
}