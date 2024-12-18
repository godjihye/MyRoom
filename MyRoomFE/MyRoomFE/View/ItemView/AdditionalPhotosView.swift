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
	@State var removeCheckAlert: Bool = false
	@State var message: String = ""
	@State var additionalItems: [PhotosPickerItem] = []
	@State var additionalPhotos: [UIImage] = []
	@State private var selectedPhoto: String = ""
	@State private var isShowingDetailImageView: Bool = false
	@State var removeCheckAlertForPhotoID: Int? = nil
	
	var itemPhotos: [ItemPhoto]?
	let itemId: Int
	private let maxImageCount = 20
	
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
								VStack {
									Image(systemName: "photo.circle")
										.font(.system(size: 60))
									Text("사진 추가하기")
										.bold()
								}
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
									removeCheckAlertForPhotoID = photo.id
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
		.confirmationDialog("추가 이미지 삭제", isPresented: Binding<Bool>(
			get: { removeCheckAlertForPhotoID != nil },
			set: { if !$0 { removeCheckAlertForPhotoID = nil } }
		)) {
			Button("삭제", role: .destructive) {
				if let photoID = removeCheckAlertForPhotoID {
					itemVM.removeAdditionalPhoto(photoId: photoID)
					removeCheckAlertForPhotoID = nil // 상태 초기화
				}
			}
			Button("취소", role: .cancel) {
				removeCheckAlertForPhotoID = nil
			}
		} message: {
			Text("이미지를 정말 삭제하시겠습니까?")
		}
		.fullScreenCover(isPresented: $isShowingDetailImageView) {
			if let itemPhotos {
				ItemDetailImageView(itemPhotos: itemPhotos)
			}
		}
	}
}
