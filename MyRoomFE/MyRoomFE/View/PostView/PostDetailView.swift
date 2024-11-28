//
//  PostDetailView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//

import SwiftUI

let postPhotoData = [PostPhotoData(id: 1, image: "test1.jpeg"),PostPhotoData(id: 2, image: "test2.jpeg")]

struct PostDetailView: View {
		@EnvironmentObject var postVM:PostViewModel
		
		var post:Posts
		let photos:[PostPhotoData]
		
		@State private var isWebViewPresented = false
		@State private var selectedPhotoIndex: Int = 0
		@State private var isPhotoViewerPresented: Bool = false
		
		var body: some View {
				ScrollView{
						VStack(spacing: 20) {
								TabView {
										ForEach(Array(photos.enumerated()), id: \.element) { index, photo in
												let strURL = "https://sayangpaysj.blob.core.windows.net/yangpa/\(photo.image)"
												if let url = URL(string: strURL) {
														AsyncImage(url: url) { image in
																image.resizable()
																		.aspectRatio(contentMode: .fill)
																		.frame(width: 400, height: 400)
																		.onTapGesture {
																				selectedPhotoIndex = index
																				isPhotoViewerPresented = true
																		}
														} placeholder: {
																Image(systemName: "photo").resizable().frame(width: 200, height: 200)
														}
												}
										}
								}.tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
										.frame(height: 400)
										.sheet(isPresented: $isPhotoViewerPresented) {
																let photoURLs = photos.map { URL(string: "https://sayangpaysj.blob.core.windows.net/yangpa/\($0.image)")! }
																		FullScreenImageView(imageURLs: photoURLs, selectedIndex: selectedPhotoIndex)
														}
								HStack{
										let strURL = "https://sayangpaysj.blob.core.windows.net/yangpa/\(post.user.userImage ?? "")"
										if let url = URL(string: strURL) {
												AsyncImage(url: url) {
														image  in image.resizable().frame(width: 50, height: 50).clipShape(RoundedRectangle(cornerRadius: 50)).padding(.leading)
												} placeholder: {
														Image(systemName: "person.circle.fill").frame(width: 50, height: 50).foregroundColor(.blue)
												}
										}
										VStack(alignment: .leading) {
												Text(post.user.nickname).padding(.bottom,5)
												HStack{
														Text("관심 \(post.postFavCnt)").font(.caption).foregroundStyle(.gray)
														Text("조회 \(post.postViewCnt)").font(.caption).foregroundStyle(.gray)
												}
										}
										Spacer()
										
								}
								Rectangle()
									 .frame(height: 1)
									 .foregroundColor(.gray)  // 선의 색상
									 .padding(.top, 0)
								
								HStack{
										Text(post.title).padding(.horizontal,10)
										Spacer()
								}
								HStack {
										Text(post.content).padding(.horizontal,10)
								}
						}
				}.background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
						.navigationTitle("글 상세")
						.navigationBarTitleDisplayMode(.inline)
		}
}

#Preview {
		let post = PostViewModel()
		PostDetailView(post: sample,photos: postPhotoData).environmentObject(post)
}
