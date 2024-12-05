//
//  UsedRowView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//

import SwiftUI

struct UsedRowView: View {
    var used: Used
    let azuerTarget = Bundle.main.object(forInfoDictionaryKey: "AZURESTORAGE") as! String
    
    var body: some View {
        
        HStack{
            let strURL = "\(azuerTarget)\(used.usedThumbnail)"
            if let url = URL(string: strURL) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .background(Color.gray.opacity(0.1))
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
                default: return "판매중"
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
                    let strURL = "\(azuerTarget)\(used.user.userImage ?? "")"
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
                    
                    
                    Image(systemName: used.isFavorite ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(used.isFavorite ? .red : .gray)
                    
                    Text("\(used.usedFavCnt)")
                        .font(.caption)
                    Spacer().frame(width: 20)
                    
                }
            }
        }
    }
}

#Preview {
		UsedRowView(used: sampleUsed)

}
