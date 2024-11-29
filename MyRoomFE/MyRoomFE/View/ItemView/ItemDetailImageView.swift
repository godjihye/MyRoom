//
//  ItemDetailImageView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/25/24.
//

import SwiftUI

struct ItemDetailImageView: View {
	@Environment(\.dismiss) private var dismiss
	@State private var isZoomed: Bool = false
	@State var selectedPhoto: String
	var itemPhotos: [ItemPhoto]
	
	var body: some View {
		NavigationView {
			VStack {
				HStack {
					Text("상세 이미지")
						.font(.headline)
					Spacer()
					Button(action: {
						dismiss()
					}) {
						Text("닫기")
							.font(.system(size: 16, weight: .semibold))
							.foregroundColor(.gray)
					}
					.padding(.bottom, 20)
				}
				.padding()
				
				Spacer()
				
				AsyncImage(url: URL(string: selectedPhoto)) { image in
						image
							.resizable()
							.aspectRatio(contentMode: isZoomed ? .fill : .fit)
							.frame(maxWidth: .infinity, maxHeight: 400)
							.onTapGesture {
								withAnimation {
									isZoomed.toggle()
								}
							}
							.cornerRadius(10)
					} placeholder: {
						ProgressView()
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
								selectedPhoto = photo.photo
								print("selectedPhoto changed!")
							}
						}
					}
				}
			}
			.navigationBarHidden(true)
		}
	}
}

#Preview {
	ItemDetailImageView(selectedPhoto: sampleItemPhoto.first?.photo ?? "", itemPhotos: sampleItemPhoto)
}
