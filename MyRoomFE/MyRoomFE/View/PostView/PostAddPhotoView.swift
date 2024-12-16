//
//  PostAddTestView.swift
//  MyRoomFE
//
//  Created by 이수정 on 12/8/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct PostAddPhotoView: View {
    @EnvironmentObject var postVM:PostViewModel
    @EnvironmentObject var itemVM:ItemViewModel
    
    @State var isPickerPresented: Bool = false
    @State private var selectPickerImage: [PhotosPickerItem] = []
    @State private var selectedOrder: [Int] = []    //선택된 순서
    @Binding  var selectPostImage: [UIImage]
    @Binding  var buttonPositions: [[CGPoint]] //각 버튼의 위치
    @Binding  var buttonItemUrls: [[String]] // 각 버튼의 URL
    @State private var currentTabIndex: Int = 0 //선택한 이미지 index
    
    
    
    //내 아이템 정보 가저오기
    @State private var isMyItemPresented: Bool = false
    @Binding  var selectMyItem: Item?
    
    @State private var location: CGPoint = .zero
    
    var body: some View {
        VStack {
            Button("Select Image") {
                isPickerPresented.toggle()
            }
            .photosPicker(isPresented: $isPickerPresented, selection: $selectPickerImage, maxSelectionCount: 30, matching: .images)
            
            HStack {
                TabView(selection: $currentTabIndex) {
                    ForEach(0..<selectPostImage.count, id: \.self) { index in
                        imageTabView(for: selectPostImage[index], index: index)
                            .tag(index)
                            .onTapGesture(count:1, coordinateSpace: .local,perform: { location in
                                isMyItemPresented.toggle()

                                self.location = CGPoint(x: location.x, y: location.y)
                                print("location chk : \(self.location)")
                            })
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(maxHeight: 400)
                .padding()
            }
        }
        .onChange(of: selectPickerImage) { newPickerImage in
            for (index, item) in newPickerImage.enumerated() where !selectedOrder.contains(index) {
                    selectedOrder.append(index)
                }
            Task {
                await loadSelectedImages(from: newPickerImage)
            }
        }
        .onChange(of: selectMyItem) { newValue in
            if let item = newValue {
                addButton(for: item)
            }
        }
        .sheet(isPresented: $isMyItemPresented) {
            UsedItemListView(selectMyItem: $selectMyItem, isMyItemPresented: $isMyItemPresented,fetchAllItem: true).edgesIgnoringSafeArea(.all)
                .environmentObject(ItemViewModel())
        }
    }
    
    func loadSelectedImages(from items: [PhotosPickerItem]) async {
        selectPostImage = []
        buttonPositions = []
        buttonItemUrls = []
        
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                selectPostImage.append(uiImage)
                
            }
        }
        
        buttonPositions = Array(repeating: [], count: selectPostImage.count)
        buttonItemUrls = Array(repeating: [], count: selectPostImage.count)
    }



    
    func addButton(for item: Item) {
        DispatchQueue.main.async {
            buttonPositions[currentTabIndex].append(location)
            buttonItemUrls[currentTabIndex].append(item.url ?? "")
        }
    }
    
    func imageTabView(for image: UIImage, index: Int) -> some View {
        
        
        GeometryReader { geo in
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400)
                    .cornerRadius(8)
                    .padding(5)
                    .onAppear {
                                    print("Image frame size: \(geo.size)")
                                }
                
                // 버튼 표시
                if buttonPositions.indices.contains(index) {
                    ForEach(buttonPositions[index], id: \.self) { position in
                        Button(action: {
                            if let posIndex = buttonPositions[index].firstIndex(of: position) {
                                buttonPositions[index].remove(at: posIndex)
                            }
                            print("Button at \(position) tapped!")
                        }) {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Text("+")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16)))
                        }
                        .position(x: position.x, y: position.y)
                    }
                }

                
            }
            
        }
    }
}



#Preview {
    PostAddPhotoView(selectPostImage: .constant([]), // 빈 배열
                     buttonPositions: .constant([]), // 빈 2D 배열
                     buttonItemUrls: .constant([]), // 빈 2D 배열
                     selectMyItem: .constant(nil)).environmentObject(ItemViewModel())
}
