//
//  ItemDetailImageView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/25/24.
//

import SwiftUI

struct ItemDetailImageView: View {
	@Environment(\.dismiss) private var dismiss
	@State private var selectedPhoto: String = ""
	@State private var selectedPhotoText: String? = nil // 선택된 이미지의 텍스트
	var itemPhotos: [ItemPhoto]
	
	var body: some View {
		NavigationView {
			VStack {
				HeaderView(onDismiss: dismiss)
				ThumbnailScrollView(
					itemPhotos: itemPhotos,
					onSelect: { photo, text in
						selectedPhoto = photo
						selectedPhotoText = text
					}
				)
				// 메인 이미지 뷰
				MainImageView(
					selectedPhoto: selectedPhoto,
					photoText: selectedPhotoText
				)
			}
			.navigationBarHidden(true)
			.onAppear {
				if let firstPhoto = itemPhotos.first {
					selectedPhoto = firstPhoto.photo
					selectedPhotoText = firstPhoto.photoTextAI
				}
			}
		}
	}
}

// MARK: - Header View
struct HeaderView: View {
	let onDismiss: DismissAction
	
	var body: some View {
		HStack {
			Text("상세 이미지")
				.font(.system(size: 16, weight: .semibold))
			Spacer()
			Button(action: {
				onDismiss()
			}) {
				Text("닫기")
					.font(.system(size: 16, weight: .semibold))
					.foregroundColor(.gray)
			}
		}
		.padding(.horizontal)
	}
}

// MARK: - Main Image View
struct MainImageView: View {
	let selectedPhoto: String
	let photoText: String?
	
	var body: some View {
		ScrollView {
			VStack {
				
				AsyncImage(url: URL(string: selectedPhoto.addingURLPrefix())) { image in
					image
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(maxWidth: .infinity)
					
				} placeholder: {
					ProgressView()
				}
				
				// 이미지에 텍스트가 있는 경우 표시
				if let photoText = photoText, !photoText.isEmpty {
					VStack {
						Text("AI로 이미지 텍스트를 요약한 내용입니다.")
							.font(.system(size: 12))
							.bold()
							.foregroundStyle(.myroom2)
							.padding(.bottom)
						Text(photoText)
							.font(.system(size: 12))
							.foregroundColor(.gray)
							.textSelection(.enabled)
					}
					.padding()
				}
			}
		}
		
	}
}

// MARK: - Thumbnail Scroll View
struct ThumbnailScrollView: View {
	let itemPhotos: [ItemPhoto]
	let onSelect: (String, String?) -> Void
	
	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack {
				ForEach(itemPhotos) { photo in
					AsyncImage(url: URL(string: photo.photo.addingURLPrefix())) { image in
						image
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: 50, height: 50)
							.clipShape(RoundedRectangle(cornerRadius: 10))
							.overlay(
								RoundedRectangle(cornerRadius: 10)
									.stroke(Color.gray.opacity(0.5))
							)
					} placeholder: {
						ProgressView()
							.frame(width: 50, height: 50)
					}
					.onTapGesture {
						onSelect(photo.photo, photo.photoTextAI)
					}
				}
			}
			.padding(.horizontal)
		}
	}
}


//#Preview {
//	ItemDetailImageView(selectedPhoto: sampleItemPhoto.first?.photo ?? "", itemPhotos: sampleItemPhoto)
//}
