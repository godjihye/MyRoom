//
//  CommentView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//
import SwiftUI

//let test = Comment(id: 1, comment: "댓글입니다", nickName: "마루미2", replies: [Comment(id: 2, comment: "대댓글입니다", nickName: "마루미", date: "2024-11-12")], date: "2024-11-12")

struct CommentRowView: View {
    @EnvironmentObject var commentVM:CommentViewModel
    @State var comment: Comment
    var addReply: (String) -> Void // 대댓글 추가 핸들러
    
    @State private var replyText = ""
    @State private var isReplying = false
    
    let azureTarget = Bundle.main.object(forInfoDictionaryKey: "AZURESTORAGE") as! String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) { // 댓글 사이 간격 늘림
            HStack(alignment: .top) {
                // 프로필 이미지
                if let userImage = comment.user.userImage, let url = URL(string: "\(azureTarget)\(userImage)") {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                            .frame(width: 40, height: 40)
                    }
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(comment.user.nickname)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(formatDateString(comment.updatedAt))")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(comment.comment)
                        .font(.body)
//                        .frame(maxWidth: .infinity, alignment: .leading) // 댓글 텍스트가 화면에 꽉 차도록 설정
                }
            }
            .padding(20)
//            .background(Color.gray.opacity(0.1))
            
            HStack {
                Button(action: { isReplying.toggle() }) {
                    Text("답댓글")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)

            // 대댓글 입력 필드
            if isReplying {
                HStack {
                    TextField("답글을 달아주세요", text: $replyText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        addReply(replyText) // 대댓글 추가
                        replyText = ""
                        isReplying = false
                    }) {
                        Image(systemName: "paperplane")
                            .foregroundColor(.gray)
                            .padding(8)
                    }
                }
                .padding(.horizontal)
            }
          
            Divider() // 댓글과 대댓글 구분을 위한 구분선
        }
        .padding(.horizontal)
//        .background(Color.gray.opacity(0.1))
        if let replies = comment.replies, !replies.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(replies, id: \.id)  { reply in
                    CommentRowView(comment: reply, addReply: { _ in })
                        .padding(.leading, 40) // 대댓글 들여쓰기
                }
            }
        }
    }
    
    func formatDateString(_ dateString: String?) -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        
        
        if let dateString = dateString,
           let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        return "Invalid Date"
    }
}

//#Preview {
//    CommentRowView(comment: test)
//}
