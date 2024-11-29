//
//  CommentView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//

import SwiftUI
let test = Comments(id: 1, comment: "댓글이에용", userImage: "soo1.jpeg",nickName: "마루미",date: "2024.11.21")
struct CommentView: View {
		let comments:Comments
		var body: some View {
				VStack{
						HStack{
								let strURL = "https://sayangpaysj.blob.core.windows.net/yangpa/\(comments.userImage)"
								if let url = URL(string: strURL) {
										AsyncImage(url: url) {
												image  in image.resizable().frame(width: 50, height: 50).clipShape(RoundedRectangle(cornerRadius: 50)).padding(.leading)
										} placeholder: {
												Image(systemName: "person.circle.fill").frame(width: 50, height: 50).foregroundColor(.blue)
										}
								}
								VStack{
										Text(comments.nickName)
										Text(comments.date).font(.caption)
												.foregroundColor(.gray)
								}
								
								Spacer()
						}
						HStack{
								Text(comments.comment).font(.headline).padding(.horizontal,30).padding(.top,10)
								Spacer()
						}
						Button {
								
						} label: {
								Image(systemName: "message").padding(.horizontal,30).padding(.top,5).foregroundColor(.gray)
								Spacer()
						}

				}
		}
}

#Preview {
		CommentView(comments: test)
}
