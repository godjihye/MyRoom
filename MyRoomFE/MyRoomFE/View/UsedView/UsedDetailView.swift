//
//  UsedDetailView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//
import Foundation
import SwiftUI
import WebKit

let photoData = [UsedPhotoData(id: 1, image: "test1.jpeg"),UsedPhotoData(id: 2, image: "test2.jpeg")]

struct UsedDetailView: View {
		@EnvironmentObject var usedVM: UsedViewModel
		@Binding var isFavorite:Bool
		@State var used:Used
		let photos:[UsedPhotoData]
		let dateFormatter = DateFormatter().dateFormat
		
		@State private var isWebViewPresented = false
		@State private var selectedPhotoIndex: Int = 0
		@State private var isPhotoViewerPresented: Bool = false
		
		let userId = 4
		
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
										let strURL = "https://sayangpaysj.blob.core.windows.net/yangpa/\(used.user.userImage ?? "")"
										if let url = URL(string: strURL) {
												AsyncImage(url: url) {
														image  in image.resizable().frame(width: 50, height: 50).clipShape(RoundedRectangle(cornerRadius: 50)).padding(.leading)
												} placeholder: {
														Image(systemName: "person.circle.fill").frame(width: 50, height: 50).foregroundColor(.blue)
												}
										}
										VStack(alignment: .leading) {
												Text(used.user.nickname).padding(.bottom,5)
												HStack{
														Text("관심 \(used.usedFavCnt)").font(.caption).foregroundStyle(.gray)
														Text("채팅 \(used.usedChatCnt)").font(.caption).foregroundStyle(.gray)
														Text("조회 \(used.usedViewCnt)").font(.caption).foregroundStyle(.gray)
												}
										}
										Spacer()
										
										if let usedUrl = used.usedUrl {
												Button {
														isWebViewPresented.toggle()
												} label: {
														Text("쇼핑몰로 가기")
												}.foregroundColor(.white)
														.padding(10)
														.background(Color.btn)
														.cornerRadius(8)
														.padding(.horizontal,10)
														.sheet(isPresented: $isWebViewPresented) {
																UsedWebView(url: URL(string: used.usedUrl ?? "")!)
															 .edgesIgnoringSafeArea(.all)
											 }
										}
										
										
								}
								Rectangle()
										.frame(height: 1)
										.foregroundColor(.gray)
										.padding(.top, 0)
								
								HStack{
										Text(used.usedTitle).padding(.horizontal,10)
										Spacer()
								}
								Divider()
								HStack{
										VStack{
												if let purchasePrice = used.purchasePrice { Text("구매가격 : \(used.purchasePrice ?? 0)") }
												if let usedPurchaseDate = used.usedPurchaseDate {Text("구매일자 : \(MyRoomFE.dateFormatter(dateString:used.usedPurchaseDate ?? ""))")}
										}
										VStack{
												if let usedExpiryDate = used.usedExpiryDate { Text("유통기한 : \(MyRoomFE.dateFormatter(dateString: used.usedExpiryDate ?? ""))")}
												if let usedOpenDate = used.usedOpenDate { Text("사용시작일자 : \(MyRoomFE.dateFormatter(dateString:used.usedOpenDate ?? ""))")}
										}
								}
								Divider()
								HStack {
										Text(used.usedDesc).padding(.horizontal,10)
								}
								
						}
				}.background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
						.navigationTitle("글 상세")
						.navigationBarTitleDisplayMode(.inline)
						.frame(maxHeight: .infinity)
				
				HStack(spacing: 20){
									 Button {
											 print("before : \(isFavorite)")
											 
											 usedVM.toggleFavorite(userId: 4, usedId: used.id, isFavorite: isFavorite) { success in
													 
													 used.toggleFavorite()
													 isFavorite.toggle()
													 print("after : \(isFavorite)")
													 print("after : \(used.isFavorite)")
											 }
									 } label: {
											 Image(systemName: isFavorite ? "heart.fill" : "heart")
															 .resizable()
															 .frame(width: 24, height: 24)
															 .foregroundColor(isFavorite ? .red : .gray)
									 }
											 .padding(.horizontal)
									 Text("\(used.usedPrice)").font(.title2)
									 Spacer()
									 Button {
											 print("chat to be continue")
									 } label: {
											 Text("채팅하기")
									 }.foregroundColor(.white)
											 .padding(10)
											 .background(Color.btn)
											 .cornerRadius(8)
											 .padding(.horizontal,10)
			 
							 }
							 .frame(height: 40)
		}
		
	 
}

func dateFormatter(dateString:String) -> String{
		
		let dateTimeParts = dateString.split(separator: "T")
		if dateTimeParts.count == 2 {
				let datePart = String(dateTimeParts[0]) // "2016-01-13"
				let timePartWithMilliseconds = String(dateTimeParts[1]) // "08:38:42.000Z"
				
				// 2. "."를 기준으로 시간과 밀리초 분리
				let timeParts = timePartWithMilliseconds.split(separator: ".")
				if let timePart = timeParts.first {
						let formattedDateTime = "\(datePart) \(timePart)" // "2016-01-13 08:38:42"
						
				}
		} else {
				print("Invalid date format")
		}
		
		return "\(dateTimeParts[0])"
}

#Preview {
		let used = UsedViewModel()
		UsedDetailView(isFavorite:.constant(false), used: userSample, photos: photoData).environmentObject(used)
//    UsedDetailView(used: userSample, photos: photoData)
}
