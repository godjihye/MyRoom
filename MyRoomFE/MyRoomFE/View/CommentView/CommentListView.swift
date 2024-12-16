import SwiftUI

struct CommentListView: View {
	@EnvironmentObject var commentVM: CommentViewModel
	@State private var newComment = ""
	@State var postId:Int
	private let userId = UserDefaults.standard.value(forKey: "userId") as! Int
	private let userName = UserDefaults.standard.string(forKey: "nickName") ?? ""
	private let userImage = UserDefaults.standard.string(forKey: "userImage") ?? ""
	
	var body: some View {
		VStack {
			if commentVM.isAlertShowing {
				Text(commentVM.message)
					.foregroundColor(.red)
			}
			
			ScrollView {
				LazyVStack {
					ForEach(commentVM.comments) { comment in
						CommentRowView(comment: comment, addReply: { replyText in
							Task {
								await commentVM.addReples(
									comment: replyText,
									postId: postId,
									userId: userId,
									parentId: comment.id
								)
								await commentVM.fetchComment(postId: postId)
							}
						})
						
					}
				}
			}
			
			// 새 댓글 추가 필드
			HStack {
				TextField("댓글을 작성해주세요", text: $newComment)
					.textFieldStyle(RoundedBorderTextFieldStyle())
				Button(action: {
					Task {
						await commentVM.addComment(
							comment: newComment,
							postId: postId,
							userId: userId
						)
						newComment = ""
						await commentVM.fetchComment(postId: postId)
					}
				}) {
					Image(systemName: "paperplane")
						.foregroundColor(.white)
						.padding(8)
						.background(Color.blue)
						.cornerRadius(5)
				}
			}
			.padding()
		}
		.padding()
		.onAppear {
			Task {
				await commentVM.fetchComment(postId: postId)
			}
		}
	}
}

//#Preview {
//    CommentListView()
//        .environmentObject(CommentViewModel())
//}
