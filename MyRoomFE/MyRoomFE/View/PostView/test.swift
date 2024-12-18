import SwiftUI
import _PhotosUI_SwiftUI

struct test: View {
    @EnvironmentObject var postVM:PostViewModel
    @Environment(\.dismiss) private var dismiss
    
//    @State var isPickerPresented: Bool = false
//    @State private var selectPostImage: [UIImage] = []
//    @State private var buttonPositions: [[CGPoint]] = []
//    @State private var buttonItemUrls: [[String]] = []
//    @State private var selectMyItem: Item?
    
    @FocusState private var titleIsFocused: Bool
    @FocusState private var contentIsFocused: Bool
    @State private var titleError: String? = nil
    @State private var contentError: String? = nil
    
    @State var postTitle : String = "식물인테리어 뽐내기"
    @State var postContent : String  = "안녕하세요 식물인테리어 뽐낼께요 \n감사합니다"
    
    let azuerTarget = Bundle.main.object(forInfoDictionaryKey: "AZURESTORAGE") as! String
    
//    let isEditMode: Bool
//    let existingPost: Post?
    
//    init(
//        isEditMode : Bool = false,
//        existingPost: Post? = nil
//    ){
//        self.isEditMode = isEditMode
//        self.existingPost = existingPost
//        _postTitle = State(initialValue: existingPost?.postTitle ?? "")
//        _postContent = State(initialValue: existingPost?.postContent ?? "")
////        _selectPostImage = State(initialValue: [UIImage](rawValue: (existingPost?.images)!) ?? "")
////
////        selectedImages: selectPostImage
////        , postTitle: postTitle
////        , postContent: postContent
////        ,selectItemUrls: buttonItemUrls
////        ,buttonPositions:buttonPositions
//        
//    }
    
    
    
    var body: some View {
        ScrollView {
            
            postImageSection
            postTitleSection
            postContentSection
            addButtom
        }
        
    }
    
    private var postImageSection : some View {
        VStack{
            
            Button("Select Image") {
//                isPickerPresented.toggle()
            }
            Image("ㅅㄷㄴㅅ") .resizable().frame(width: 400, height: 400).padding(.leading)
               
            
        }
    }
    
    private var postTitleSection : some View {
        VStack {
            Text("제목")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("제목", text: $postTitle)
                .padding()
                .padding(.horizontal)
//                .focused($titleIsFocused)
//                .overlay(
//                    titleError != nil ?
//                    Text(titleError!)
//                        .foregroundColor(.red)
//                        .font(.caption)
//                        .padding(.top, 4)
//                        .padding(.horizontal, 20)
//                    : nil,
//                    alignment: .bottomLeading
//                )
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray, lineWidth: 2)
                        .background(Color.white)
                        .cornerRadius(16)
                )
                .onAppear {
                    UIApplication.shared.hideKeyboard()
                }
        }.padding(.horizontal)
    }
    
    private var postContentSection : some View {
        VStack{
            Text("자세한 설명")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextEditor(text: $postContent)
                .frame(height: 200)
//                .focused($contentIsFocused)
                .padding()
                .padding(.horizontal)
//                .overlay(
//                    contentError != nil ?
//                    Text(contentError!)
//                        .foregroundColor(.red)
//                        .font(.caption)
//                        .padding(.top, 4)
//                        .padding(.horizontal, 8)
//                    : nil,
//                    alignment: .bottomLeading
//                )
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray, lineWidth: 2)
                        .background(Color.white)
                        .cornerRadius(16)
                )
//                .onAppear {
//                    UIApplication.shared.hideKeyboard()
//                }
        }.padding(.horizontal)
    }
    
    
    
    private var addButtom : some View {
        
        WideButton(title: "작성완료", backgroundColor: .accent) {
//            if postTitle.isEmpty {
//                titleError = "제목을 입력해주세요."
//                titleIsFocused = true // 타이틀 필드로 포커스 이동
//                return
//            } else {
//                titleError = nil
//            }
//            if postContent.isEmpty {
//                contentError = "내용을 입력해주세요."
//                contentIsFocused = true // 콘텐츠 필드로 포커스 이동
//                return
//            } else {
//                contentError = nil
//            }
//            if isEditMode {
//                Task{
//                    // 편집 모드일 때 수정 로직
////                    await postVM.updatePost(
////                        usedId: existingUsed?.id ?? 0,
////                        newTitle: usedTitle,
////                        newPrice: usedPrice,
////                        newContent: usedContent,
////                        newItem: selectMyItem
////                    )
//                    
//                }
//            } else {
//                // 새 아이템 등록 로직
//                postVM.addPost(selectedImages: selectPostImage, postTitle: postTitle, postContent: postContent,selectItemUrls: buttonItemUrls,buttonPositions:buttonPositions)
//                
//            }
            
            
//        }.alert("게시글 등록", isPresented: $postVM.isAddShowing) {
//            Button("확인") {
//                Task{
//                    postVM.fetchPosts()
//                    dismiss()
//                }
//            }
//        } message: {
//            Text(postVM.message)
        }
    
    }
    
}

#Preview {
    PostAddView()
}
