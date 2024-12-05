import SwiftUI
import _PhotosUI_SwiftUI

struct PostAddView: View {
    @EnvironmentObject var postVM:PostViewModel
    
    @State var isPickerPresented: Bool = false
    @State private var selectedItems: [PhotosPickerItem] = []  // 선택된 항목들
    @State private var selectedImages: [UIImage] = []
    @State private var buttonPositions: [[CGPoint]] = []  // 각 이미지별 버튼 위치 배열
    @State private var buttonIndex: Int = 0  // 버튼의 고유 인덱스
    
    @FocusState private var titleIsFocused: Bool
    @FocusState private var contentIsFocused: Bool
    @State private var titleError: String? = nil
    @State private var contentError: String? = nil
    
    @State var postTitle : String = "title"
    @State var postContent : String  = "저는 산업디자인 분야에서 15년 이상 근무하고 현재는 프리랜서 활동을 조금씩 하며 딸, 아들 그리고 저희 가족의 귀여움을 독차지 하는 도도냥 포포와 함께 생활하고 있답니다. 미니멀라이프를 추구하지만 아이들, 반려묘와 함께 하기 때문에 항상 맥시멀라이프가 되어버리네요. 그래도 최대한 깔끔한 분위기로 홈스타일링을 하기 위해 노력 중이에요.소소하고 평범하지만, 소품과 가구 배치를 이용해 다양한 공간을 연출하고 있는 저희 집을 소개합니다!"
    
    var body: some View {
        VStack {
            Button("Select Image") {
                isPickerPresented.toggle()
            }
            .photosPicker(isPresented: $isPickerPresented, selection: $selectedItems, maxSelectionCount: 30, matching: .images)
            
            // 이미지 선택 후, 탭을 통해 버튼 추가
            HStack {
                TabView {
                    ForEach(0..<selectedImages.count, id: \.self) { index in
                        imageTabView(for: selectedImages[index], index: index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(maxHeight: 400)
                .padding()
            }
        }
        .onChange(of: selectedItems) { newItems in
            Task {
                // 선택된 사진을 가져오기
                selectedImages = []
                buttonPositions = [] // 이미지가 새로 선택되면 각 이미지에 대한 버튼 위치도 초기화
                for item in newItems {
                    // 선택된 사진을 UIImage로 변환
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImages.append(uiImage)
                        buttonPositions.append([]) // 각 이미지에 대해 독립적인 버튼 위치 배열 생성
                    }
                }
            }
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
        TextField("당신의 이야기를 들려주세요!", text: $postContent)
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
                await postVM.addPost(selectedImages: selectedImages, postTitle: postTitle, postContent: postContent)
            }
            
        }// true가되면 detailview를 보여주라
    }
    
    
    
    
    
    
    // TabView에서 각 이미지를 처리하는 별도 View로 분리
    private func imageTabView(for image: UIImage, index: Int) -> some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 400)
                .cornerRadius(8)
                .padding(5)
            
            // 각 이미지에 대해 독립적으로 버튼을 추가
            ForEach(buttonPositions[index].indices, id: \.self) { idx in
                let position = buttonPositions[index][idx]
                Button(action: {
                    // 버튼 클릭 이벤트
                    print("Button \(idx) tapped on image \(index)!")
                }) {
                    Text("Button \(idx)")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .position(position)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            // 버튼을 드래그할 때 위치 업데이트
                            buttonPositions[index][idx] = value.location
                        }
                )
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    // 이미지를 클릭하면 해당 이미지의 버튼 위치 추가
                    if buttonPositions[index].isEmpty {
                        buttonPositions[index].append(value.location)
                    }
                }
        )
    }
}



#Preview {
    PostAddView()
}
