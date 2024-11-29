//
//  AdditionalPhotosView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/25/24.
//

import SwiftUI

struct AdditionalPhotosView: View {
	
	@State private var selectedPhoto: String = ""
	@State private var isShowingDetailImageView: Bool = false
	var itemPhotos: [ItemPhoto]
	
	var body: some View {
		VStack(alignment: .leading) {
			Label("추가 사진(사용설명서)", systemImage: "tag.fill")
				.font(.subheadline)
				.foregroundColor(.primary)
				.onTapGesture {
					isShowingDetailImageView = true
					print("isShowingDetailImageView = true")
				}
			ScrollView(.horizontal){
				HStack {
					ForEach(itemPhotos) { photo in
						AsyncImage(url: URL(string: photo.photo)) { image in
							image
								.resizable()
								.scaledToFit()
								.frame(width: 100, height: 100)
								.onTapGesture {
									selectedPhoto = photo.photo
									isShowingDetailImageView = true
								}
								.cornerRadius(10)
						} placeholder: {
							ProgressView()
						}
					}
				}
			}
		}
		.fullScreenCover(isPresented: $isShowingDetailImageView) {
				 ItemDetailImageView(selectedPhoto: selectedPhoto, itemPhotos: itemPhotos)
			 
		 }
	}
}
