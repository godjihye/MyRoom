import SwiftUI
import _PhotosUI_SwiftUI

struct PostAddView: View {
    @State var isPickerPresented: Bool = false
    @State private var selectedItems: [PhotosPickerItem] = []  // 선택된 항목들
    @State private var selectedImages: [UIImage] = []
    @State private var buttonPositions: [[CGPoint]] = []  // 각 이미지별 버튼 위치 배열
    @State private var buttonIndex: Int = 0  // 버튼의 고유 인덱스

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
                .frame(height: 400)
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
