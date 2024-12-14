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
		@State private var isShowingImageSource = false
		@State private var isPhotosPickerPresented = false
		@State private var isCameraPresented = false
		@State private var additionalItems: [PhotosPickerItem] = []
		@State private var additionalPhotos: [UIImage] = []
		@State private var cameraPhoto: UIImage?
		
		private let maxImageCount = 20
		let itemId: Int
		let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]
		
		var body: some View {
				VStack {
						selectedImagesView
						selectImageBtnView
						Spacer()
						saveBtn
				}
				.navigationTitle("추가 이미지 등록")
				.toolbar {
						ToolbarItem(placement: .principal) {
								Text("추가 이미지 등록")
						}
				}
				.onChange(of: additionalItems) { _, _ in
						handleAdditionalItemsChange()
				}
				.onChange(of: cameraPhoto) { _, newValue in
						if let photo = newValue {  // 옵셔널 바인딩으로 처리
								additionalPhotos.append(photo)
						}
				}
				.alert("추가 이미지 등록", isPresented: $itemVM.isShowingAlertAddAdditionalPhotos) {
						Button("확인", role: .cancel) {
								dismiss()
						}
				} message: {
						Text(itemVM.addAdditionalPhotosMessage)
				}
				.sheet(isPresented: $isCameraPresented) {
						CameraPicker(image: $cameraPhoto, sourceType: .camera)
				}
				.photosPicker(
						isPresented: $isPhotosPickerPresented,
						selection: $additionalItems,
						maxSelectionCount: maxImageCount,
						matching: .images
				)
		}
		
		// MARK: - Subviews
		private var selectedImagesView: some View {
				ScrollView {
						LazyVGrid(columns: columns, spacing: 10) {
								ForEach(additionalPhotos, id: \.self) { photo in
										Image(uiImage: photo)
												.resizable()
												.scaledToFill()
												.frame(width: 100, height: 100)
												.cornerRadius(10)
								}
						}
						.padding()
				}
		}
		
		private var selectImageBtnView: some View {
				Button {
						isShowingImageSource = true
				} label: {
						Text("추가 이미지 선택")
				}
				.buttonStyle(.bordered)
				.confirmationDialog("사진 소스 선택", isPresented: $isShowingImageSource) {
						Button("포토 앨범") {
								isPhotosPickerPresented = true
						}
						Button("카메라") {
								isCameraPresented = true
						}
				}
		}
		
		private var saveBtn: some View {
				Button(action: {
						itemVM.addAdditionalPhotos(images: additionalPhotos, itemId: itemId)
				}) {
						Text("추가 이미지 등록")
								.frame(maxWidth: .infinity)
								.padding()
								.background(Color.accentColor)
								.foregroundColor(.white)
								.cornerRadius(10)
				}
				.padding()
		}
		
		// MARK: - Functions
		private func handleAdditionalItemsChange() {
				Task {
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
		AddAdditionalPhotosView(itemId: 1)
				.environmentObject(itemVM)
}
