//
//  UsedRowView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//

import SwiftUI

let userSample = Useds(id: 1, usedTitle: "Hite zero 맥주 6개입",usedPrice: 50000, usedDesc: "수납침대를 이용하여 자주쓰지 않는 물건들을 안보이도록 정리해요 정말쉽죠 한번 같이해봐요 이렇게 쉬울수가없어요 돈만있음 다할 수 있습니다", user: User(nickname: "마루미", userImage: "soo1.jpeg"), usedUrl: "https://www.slowand.com/product/%EC%97%90%EB%B3%B4%EB%8B%88-%EB%B2%A8%ED%8A%B8%EC%84%B8%ED%8A%B8-%EB%A1%B1%EC%8A%A4%EC%BB%A4%ED%8A%B8-belt-3-size/8864/category/70/display/1/",usedStatus: 0, usedPurchaseDate: "2016-01-13T08:38:42.000Z",usedExpiryDate:"2016-01-13T08:38:42.000Z",usedOpenDate:"2016-01-13T08:38:42.000Z",purchasePrice:20000,usedFavCnt:11, usedViewCnt: 280, usedChatCnt: 728 ,images: [UsedPhotoData(id: 1, image: "test1.jpeg"),UsedPhotoData(id: 2, image: "test2.jpeg")], usedThumbnail: "test1.jpeg", isFavorite: true, usedFav: [UsedFavData(id: 1,usedId: 4, userId: 4)], updatedAt: "2016-01-13T08:38:42.000Z")
struct UsedRowView: View {
		var used: Useds
		@State var isFavorite:Bool = false
		var body: some View {
				
				HStack{
						let strURL = "https://sayangpaysj.blob.core.windows.net/yangpa/\(used.usedThumbnail)"
						if let url = URL(string: strURL) {
								AsyncImage(url: url) { image in
										image.resizable()
												.aspectRatio(contentMode: .fill)
												.frame(width: 70, height: 70)
												.background(Color.gray.opacity(0.1)) // 배경색 추가
												.clipShape(RoundedRectangle(cornerRadius: 12))
												.overlay(
														RoundedRectangle(cornerRadius: 12)
																.stroke(Color.gray.opacity(0.3), lineWidth: 1)
												)
								} placeholder: {
										Image(systemName: "photo").frame(width: 70, height: 70)
								}
						}
						
						var status: String {
								switch used.usedStatus {
								case 1: return "예약중"
								case 2: return "거래완료"
								default: return "거래중"
								}
						}
						
						VStack(alignment:.leading) {
								Text(used.usedTitle).font(.headline)
										.foregroundColor(.primary)
										.lineLimit(1)
								
								HStack {
										Text(status).font(.caption);
										Text("\(used.usedPrice)").padding(.horizontal,10)
								}
							 
								
								HStack {
										let strURL = "https://sayangpaysj.blob.core.windows.net/yangpa/\(used.user.userImage ?? "")"
										if let url = URL(string: strURL) {
												AsyncImage(url: url) {
														image  in image.resizable().frame(width: 20, height: 20).clipShape(RoundedRectangle(cornerRadius: 12))
												} placeholder: {
														Image(systemName: "person.circle.fill").frame(width: 10, height: 10).foregroundColor(.blue)
												}
										}
										Text(used.user.nickname)
												.font(.caption)
												.foregroundColor(.gray)
										Text("조회수 \(used.usedViewCnt)")
												.font(.caption)
												.foregroundColor(.gray)
										Spacer()
										
										
										Image(systemName: isFavorite ? "heart.fill" : "heart")
														.resizable()
														.frame(width: 15, height: 15)
														.foregroundColor(isFavorite ? .red : .gray)
										
										Text("\(used.usedFavCnt)")
												.font(.caption)
										Spacer().frame(width: 20)
										
								}
						}
				}
		}
}

#Preview {
		UsedRowView(used: userSample)
}
