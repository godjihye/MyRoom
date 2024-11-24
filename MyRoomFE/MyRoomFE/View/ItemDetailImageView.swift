//
//  ItemDetailImageView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/25/24.
//

import SwiftUI

struct ItemDetailImageView: View {
	//@Environment(\.dismiss) private var dismiss
	@State private var isZoomed: Bool = false
	@State var selectedPhotoId: Int
	var itemPhotos: [ItemPhoto]
	var body: some View {
		NavigationView {
			VStack {
				// 상단 제목
				HStack {
					Text("상세 이미지")
						.font(.headline)
					Spacer()
					// 닫기 버튼
					Button(action: {
						print("닫기 버튼 눌림") // 닫기 동작
						//dismiss()
					}) {
						Text("닫기")
							.font(.system(size: 16, weight: .semibold))
							.foregroundColor(.gray)
					}
					.padding(.bottom, 20)
				}
				.padding()
				
				Spacer()
				
				// 이미지 영역
				if let itemPhoto = itemPhotos.first?.photo {
					AsyncImage(url: URL(string: itemPhoto)) { image in
						image
							.resizable()
							.aspectRatio(contentMode: isZoomed ? .fill : .fit)
						//										.scaledToFit()
							.frame(maxWidth: .infinity, maxHeight: 400)
							.onTapGesture {
								withAnimation {
									isZoomed.toggle() // 탭하면 확대/축소
								}
							}
							.cornerRadius(10)
					} placeholder: {
						ProgressView()
					}
				}
				Spacer()
				
				ScrollView(.horizontal) {
					HStack {
						ForEach(itemPhotos) { photo in
							AsyncImage(url: URL(string: photo.photo)) { image in
								image.image?.resizable()
									.frame(width: 50, height: 50)
									.overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray).opacity(0.5))
							}
							.onTapGesture {
								selectedPhotoId = photo.id
								print(selectedPhotoId)
							}
						}
					}
				}
			}
			.navigationBarHidden(true) // 상단 네비게이션 바 숨김
		}
	}
}

#Preview {
	ItemDetailImageView(selectedPhotoId: 1, itemPhotos: sampleItemPhoto)
}
