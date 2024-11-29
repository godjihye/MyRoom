//
//  PostRowView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/17/24.
//

import SwiftUI

let sample = Posts(id: 1, title: "7평원룸 수납꿀팁", content: "수납침대를 이용하여 자주쓰지 않는 물건들을 안보이도록 정리해요 정말쉽죠 한번 같이해봐요 이렇게 쉬울수가없어요 돈만있음 다할 수 있습니다", nickName: "마루미", userImage: "soo1.jpeg", thumbnail: "test1.jpeg", user: User(nickname: "마루미", userImage: "soo1.jpeg"), postFavCnt: 280, postViewCnt: 728, images: [PostPhotoData(id: 1, image: "test1.jpeg"),PostPhotoData(id: 2, image: "test2.jpeg")])
struct PostRowView: View {
    var post:Posts
    var body: some View {
        
        HStack{
            let strURL = "https://sayangpaysj.blob.core.windows.net/yangpa/\(post.thumbnail)"
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
                    Text(post.title).font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    Spacer()
                }
                Text(post.content).font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack {
                    let strURL = "https://sayangpaysj.blob.core.windows.net/yangpa/\(post.userImage)"
                    if let url = URL(string: strURL) {
                        AsyncImage(url: url) {
                            image  in image.resizable().frame(width: 20, height: 20).clipShape(RoundedRectangle(cornerRadius: 12))
                        } placeholder: {
                            Image(systemName: "person.circle.fill").frame(width: 10, height: 10).foregroundColor(.blue)
                        }
                    }
                    Text(post.nickName)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("조회수 \(post.postViewCnt)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Image(systemName: "hand.thumbsup")
                    Text("\(post.postFavCnt)")
                        .font(.caption)
                    Spacer().frame(width: 20)
                    
                }
            }
        }
    }
}


#Preview {
    PostRowView(post:sample)
}
