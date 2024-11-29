//
//  CommentAddView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//

import SwiftUI

struct CommentAddView: View {
    @Binding var comment : String
    var body: some View {
        
        HStack{
            TextField("댓글을입력해주세요", text: $comment).padding(10)  // 여백을 추가하여 테두리와 내용이 붙지 않게
                .background(Color.gray.opacity(0.2))  // 배경색 설정 (optional)
                .cornerRadius(20)  // 테두리 둥글게 설정
                .padding(.horizontal)
            Button {
                
            } label: {
                Image(systemName: "paperplane").resizable().frame(width: 25,height: 25).padding(.horizontal, 10)
            }

        }
    }
}

#Preview {
    CommentAddView(comment: .constant(""))
}
