import SwiftUI
import _PhotosUI_SwiftUI

struct PostAddView: View {
    @EnvironmentObject var postVM:PostViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var isPickerPresented: Bool = false
    @State private var selectPostImage: [UIImage] = []
    @State private var buttonPositions: [[CGPoint]] = []
    @State private var buttonItemUrls: [[String]] = []
    @State private var selectMyItem: Item?
    
    @FocusState private var titleIsFocused: Bool
    @FocusState private var contentIsFocused: Bool
    @State private var titleError: String? = nil
    @State private var contentError: String? = nil
    
    @State var postTitle : String = ""
    @State var postContent : String  = ""
    
    let isEditMode: Bool
    let existingPost: Post?
    
    init(
        isEditMode : Bool = false,
        existingPost: Post? = nil
    ){
        self.isEditMode = isEditMode
        self.existingPost = existingPost
        _postTitle = State(initialValue: existingPost?.postTitle ?? "")
        _postContent = State(initialValue: existingPost?.postContent ?? "")
        if let images = existingPost?.images {
            let initialImages = images.map { $0.image }.compactMap {imagePath in
                if let url = URL(string: imagePath.addingURLPrefix()),
                   let data = try? Data(contentsOf: url) {
                    return UIImage(data: data)
                }
                    return nil}
                _selectPostImage = State(initialValue: initialImages)
                
                let initialButtonPositions = images.compactMap { $0.btnData?.map { CGPoint(x: $0.positionX ?? 0, y: $0.positionY ?? 0) } }
                _buttonPositions = State(initialValue: initialButtonPositions)
                
                let initialButtonUrls = images.compactMap { $0.btnData?.compactMap { $0.itemUrl ?? "" } }
                _buttonItemUrls = State(initialValue: initialButtonUrls)
            }
        
    }
    
    
    
    var body: some View {
        ScrollView {
            postImageSection
            postTitleSection
            postContentSection
            addButtom
        }
    }
    
    private var postImageSection : some View {
        VStack {
            PostAddPhotoView(selectPostImage: $selectPostImage, buttonPositions: $buttonPositions, buttonItemUrls: $buttonItemUrls ,selectMyItem: $selectMyItem)
                .environmentObject(ItemViewModel())
                .frame(height: 400)
        }.padding(.horizontal, 0)
            .frame(maxWidth: .infinity)
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
                .focused($titleIsFocused)
                .overlay(
                    titleError != nil ?
                    Text(titleError!)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 4)
                        .padding(.horizontal, 20)
                    : nil,
                    alignment: .bottomLeading
                )
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
                .focused($contentIsFocused)
                .padding()
                .padding(.horizontal)
                .overlay(
                    contentError != nil ?
                    Text(contentError!)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 4)
                        .padding(.horizontal, 8)
                    : nil,
                    alignment: .bottomLeading
                )
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
    
    
    
    private var addButtom : some View {
        
        WideButton(title: "작성완료", backgroundColor: .accent) {
            if postTitle.isEmpty {
                titleError = "제목을 입력해주세요."
                titleIsFocused = true // 타이틀 필드로 포커스 이동
                return
            } else {
                titleError = nil
            }
            if postContent.isEmpty {
                contentError = "내용을 입력해주세요."
                contentIsFocused = true // 콘텐츠 필드로 포커스 이동
                return
            } else {
                contentError = nil
            }
           
            if isEditMode,let existingImagesCount = existingPost?.images.count {
                //편집모드
                    postVM.updatePost(
                        postId: existingPost?.id ?? 0,
                        selectedImages: selectPostImage,
                        postTitle: postTitle,
                        postContent: postContent,
                        selectItemUrls: buttonItemUrls,
                        buttonPositions:buttonPositions,
                        existingImagesCount:existingImagesCount
                    )
            } else {
                //새글작성
                postVM.addPost(selectedImages: selectPostImage, postTitle: postTitle, postContent: postContent,selectItemUrls: buttonItemUrls,buttonPositions:buttonPositions)
            }
            
            
        }.alert("게시글 등록", isPresented: $postVM.isAddShowing) {
            Button("확인") {
                
                    postVM.fetchPosts()
                    dismiss()
                
            }
        } message: {
            Text(postVM.message)
        }
    
    }
    
}

//#Preview {
//    PostAddView()
//}
