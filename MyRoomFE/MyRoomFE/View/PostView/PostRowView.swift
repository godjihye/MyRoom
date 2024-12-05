//
//  PostRowView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/17/24.
//

import SwiftUI

struct PostRowView: View {
    var post:Post
    let azuerTarget = Bundle.main.object(forInfoDictionaryKey: "AZURESTORAGE") as! String
    var body: some View {
        
        HStack{
            let strURL = "\(azuerTarget)\(post.postThumbnail)"
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
            
            VStack(alignment:.leading) {
                HStack {
                    Text(post.postTitle).font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    Spacer()
                }
                Text(post.postContent).font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack {
                    let strURL = "\(azuerTarget)\(post.user.userImage ?? "")"
                    if let url = URL(string: strURL) {
                        AsyncImage(url: url) {
                            image  in image.resizable().frame(width: 20, height: 20).clipShape(RoundedRectangle(cornerRadius: 12))
                        } placeholder: {
                            Image(systemName: "person.circle.fill").frame(width: 10, height: 10).foregroundColor(.blue)
                        }
                    }
                    Text(post.user.nickname)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("조회수 \(post.postViewCnt)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Image(systemName: post.isFavorite ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(post.isFavorite ? .red : .gray)
                    Text("\(post.postFavCnt)")
                        .font(.caption)
                    Spacer().frame(width: 20)
                    
                }
            }
        }
    }
}


#Preview {
    PostRowView(post:samplePost)
}
