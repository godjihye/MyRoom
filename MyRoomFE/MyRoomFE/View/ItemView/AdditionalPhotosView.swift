//
//  AdditionalPhotosView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/25/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct AdditionalPhotosView: View {
	@EnvironmentObject var itemVM: ItemViewModel
	@State var isPhotosPickerPresented: Bool = false
	@State var showAlert: Bool = false
	@State var message: String = ""
	@State var additionalItems: [PhotosPickerItem] = []
	@State var additionalPhotos: [UIImage] = []
	private let maxImageCount = 20
	@State private var selectedPhoto: String = ""
	@State private var isShowingDetailImageView: Bool = false
	var itemPhotos: [ItemPhoto]?
	let itemId: Int
	var body: some View {
		VStack(alignment: .leading) {
			Label("추가 사진(사용설명서)", systemImage: "tag.fill")
				.font(.subheadline)
				.foregroundColor(.primary)
				.onTapGesture {
					isShowingDetailImageView = true
				}
			ScrollView(.horizontal, showsIndicators: false){
				HStack {
					NavigationLink {
						AddAdditionalPhotosView(itemId: itemId)
					} label: {
						Rectangle()
							.fill(.clear)
							.frame(width: 100, height: 100)
							.overlay {
								Image(systemName: "photo.circle")
									.font(.system(size: 80))
							}
					}
					if let itemPhotos {
						ForEach(itemPhotos) { photo in
							VStack {
								AsyncImage(url: URL(string: photo.photo.addingURLPrefix())) { image in
									image
										.resizable()
										.scaledToFill()
										.frame(width: 100, height: 100)
										.onTapGesture {
											selectedPhoto = photo.photo
											isShowingDetailImageView = true
										}
										.cornerRadius(10)
								} placeholder: {
									ProgressView()
								}
								Button {
									itemVM.removeAdditionalPhoto(photoId: photo.id)
								} label: {
									Text("삭제")
										.foregroundStyle(.red)
								}
							}
						}
					}
				}
			}
		}
		.fullScreenCover(isPresented: $isShowingDetailImageView) {
			if let itemPhotos {
				ItemDetailImageView(selectedPhoto: selectedPhoto, itemPhotos: itemPhotos)
			}
		}
	}
}
