//
//  AddAdditionalPhotosView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/3/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct AddAdditionalPhotosView: View {
	@Environment(\.dismiss) private var dismiss
	@EnvironmentObject var itemVM: ItemViewModel
	@State var isPhotosPickerPresented: Bool = false
	@State var showAlert: Bool = false
	@State var message: String = ""
	@State var additionalItems: [PhotosPickerItem] = []
	@State var additionalPhotos: [UIImage] = []
	private let maxImageCount = 20
	let itemId: Int
	let columns = [
		GridItem(.flexible(), spacing: 10),
		GridItem(.flexible(), spacing: 10)
	]
	var body: some View {
		VStack {
			selectedImagesView
			selectImageBtnView
			Spacer()
			saveBtn
		}
		.toolbar(content: {
			ToolbarItem(placement: .principal) {
				Text("추가 이미지 등록")
			}
		})
		.onChange(of: additionalItems, { oldValue, newValue in handleAdditionalItemsChange() })
		.alert("추가 이미지 등록", isPresented: $itemVM.isShowingAlertAddAdditionalPhotos) {
			Button("확인", role: .cancel) {
				dismiss()
			}
		} message: {
			Text(itemVM.addAdditionalPhotosMessage)
		}

	}
	
	private var selectedImagesView: some View {
		Group {
			GeometryReader { reader in
				if additionalPhotos.count < 2 {
					Image(uiImage: additionalPhotos.first ?? UIImage())
						.resizable()
						.scaledToFill()
						.frame(width: reader.size.width)
						.cornerRadius(10)
				} else {
					
					LazyVGrid(columns: columns, spacing: 10) {
						ForEach(additionalPhotos, id: \.self) { photo in
							Image(uiImage: photo)
								.resizable()
								.scaledToFill()
								.frame(width: reader.size.width / 2 - 20, height: reader.size.width / 2 - 20)
								.cornerRadius(10)
						}
					}
				}
			}.padding()
		}
	}
	
	private var selectImageBtnView: some View {
		Button("추가 이미지 선택") {
			if additionalPhotos.count < maxImageCount {
				isPhotosPickerPresented = true
			} else {
				showAlert = true
				message = "이미지는 최대 \(maxImageCount)장까지 선택할 수 있습니다."
			}
		}
		.buttonStyle(.bordered)
		.photosPicker(isPresented: $isPhotosPickerPresented, selection: $additionalItems, maxSelectionCount: maxImageCount, matching: .images)
	}
	
	private var saveBtn: some View {
		WideButton(title: "추가 이미지 등록", backgroundColor: .accent) {
			Task {
				await itemVM.addAdditionalPhotos(images: additionalPhotos, itemId: itemId)
			}
		}
		.padding()
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
}

#Preview {
	let itemVM = ItemViewModel()
	AddAdditionalPhotosView(itemId: 1).environmentObject(itemVM)
}
