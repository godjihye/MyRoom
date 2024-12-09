import SwiftUI
import _PhotosUI_SwiftUI

struct PostAddView: View {
    @EnvironmentObject var postVM:PostViewModel
    
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
    @State var postContent : String  = "저는 산업디자인 분야에서 15년 이상 근무하고 현재는 프리랜서 활동을 조금씩 하며 딸, 아들 그리고 저희 가족의 귀여움을 독차지 하는 도도냥 포포와 함께 생활하고 있답니다. 미니멀라이프를 추구하지만 아이들, 반려묘와 함께 하기 때문에 항상 맥시멀라이프가 되어버리네요. 그래도 최대한 깔끔한 분위기로 홈스타일링을 하기 위해 노력 중이에요.소소하고 평범하지만, 소품과 가구 배치를 이용해 다양한 공간을 연출하고 있는 저희 집을 소개합니다!"
    
    var body: some View {
        VStack {
            PostAddPhotoView(selectPostImage: $selectPostImage, buttonPositions: $buttonPositions, buttonItemUrls: $buttonItemUrls, selectMyItem: $selectMyItem).environmentObject(ItemViewModel())
        }
        
        
        Text("제목")
            .padding(.horizontal)
            .font(.headline)
            .foregroundColor(.gray)
        TextField("제목", text: $postTitle)
            .padding()
            .background(Color.white) // 카드 배경
            .cornerRadius(16) // 둥근 모서리
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4) // 그림자
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
        
        Text("자세한 설명")
            .font(.headline)
            .foregroundColor(.gray)
            .padding(.horizontal)
        TextEditor(text: $postContent)
            .frame(height: 200)
            .focused($contentIsFocused)
            .padding()
            .background(Color.white) // 카드 배경
            .cornerRadius(16) // 둥근 모서리
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4) // 그림자
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
        
        WideButton(title: "작성완료", backgroundColor: Color.blue) {
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
            Task{
                await postVM.addPost(selectedImages: selectPostImage, postTitle: postTitle, postContent: postContent,selectItemUrl: buttonItemUrls,buttonPositions:buttonPositions)
            }
            
        }// true가되면 detailview를 보여주라
    }
}

//#Preview {
//    PostAddView()
//}
