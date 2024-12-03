//
//  AddAdditionalPhotosView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/3/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct AddAdditionalPhotosView: View {
	@State var isPhotosPickerPresented: Bool = false
	@State var showAlert: Bool = false
	@State var message: String = ""
	@State var additionalItems: [PhotosPickerItem] = []
	@State var additionalPhotos: [UIImage] = []
	private let maxImageCount = 20
	var body: some View {		
		Section(header: Text("추가 이미지 정보")) {
			ScrollView(.horizontal) {
				HStack {
					ForEach(additionalPhotos, id: \.self) { photo in
						Image(uiImage: photo)
							.resizable()
							.scaledToFit()
							.frame(width: 100, height: 100)
							.cornerRadius(10)
					}
				}
			}
			Button("추가 이미지 선택") {
				if additionalPhotos.count < maxImageCount {
					isPhotosPickerPresented = true
				} else {
					showAlert = true
					message = "이미지는 최대 \(maxImageCount)장까지 선택할 수 있습니다."
				}
			}
			.photosPicker(isPresented: $isPhotosPickerPresented, selection: $additionalItems, maxSelectionCount: maxImageCount - additionalPhotos.count, matching: .images)
		}
		.onChange(of: additionalItems, { oldValue, newValue in handleAdditionalItemsChange() })
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
	AddAdditionalPhotosView()
}
