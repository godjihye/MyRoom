//
//  UsedAddView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct UsedAddView: View {
    @EnvironmentObject var usedVM:UsedViewModel
    
    @FocusState private var titleIsFocused: Bool
    @FocusState private var contentIsFocused: Bool
    
    @State private var titleError: String? = nil
    @State private var contentError: String? = nil
    
    
    @State var isPickerPresented: Bool = false
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    private let maxImageCount = 10  //사진 개수
    @State private var showAlert = false
    @State private var message = ""
    
    //내 아이템 정보 가저오기
    @State private var isMyItemPresented: Bool = false
    @State private var selectMyItem: Item?
    
    @State var usedTitle : String = "title"
    @State var usedPrice : Int  = 1000
    @State var usedContent : String  = "내용"
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Button {
                        if selectedImages.count < 10 {
                            isPickerPresented.toggle()
                            print(selectedImages.count)
                        }else{
                            showAlert = true
                            message = "이미지는 10개까지 선택할 수 있습니다."
                        }
                    } label: {
                        Image(systemName: "camera").resizable().frame(width: 30,height: 30).padding(30)
                    }.photosPicker(isPresented: $isPickerPresented, selection: $selectedItems, maxSelectionCount: maxImageCount - selectedImages.count, matching: .images)
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("알림"),
                                message: Text(message),
                                dismissButton: .default(Text("확인"))
                            )
                        }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(Array(selectedImages.enumerated()), id: \.element) {index, image in
                                ZStack (alignment: .topTrailing){
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(8)
                                        .padding(5)
                                    
                                    
                                    Button(action: {
                                        removeImage(at: index)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                            .padding(4)
                                    }.background(Color.white.opacity(0.7))
                                        .clipShape(Circle())
                                        .offset(x: 5, y: -5)
                                }
                            }
                        }.onChange(of: selectedItems) { newItems in
                            Task {
                                for item in newItems {
                                    if let data = try? await item.loadTransferable(type: Data.self),
                                       let image = UIImage(data: data) {
                                        selectedImages.append(image)
                                    }
                                }
                                selectedItems = [] // PhotoPicker 상태 초기화
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading){
                    
                    Button {
                        print("item select")
                        isMyItemPresented.toggle()
                    } label: {
                        Image(systemName: "plus").resizable().frame(width: 20,height: 20)
                    }
                    .cornerRadius(8)
                    .padding(.horizontal).padding(.bottom)
                    .sheet(isPresented: $isMyItemPresented) {
                        UsedItemListView(selectMyItem: $selectMyItem, isMyItemPresented: $isMyItemPresented)
                            .edgesIgnoringSafeArea(.all)
                    }
                    
                    VStack(alignment: .leading,spacing: 10) {
                        if let selectMyItem = selectMyItem {
                            Text("Item Info")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            VStack {
                                itemInfo(title: "구매일자", selectMyItem: formatDateString(selectMyItem.purchaseDate))
                                itemInfo(title: "구매가격", selectMyItem: selectMyItem.price.map { "\($0)" })
                                itemInfo(title: "유통기한", selectMyItem: formatDateString(selectMyItem.expiryDate))
                                itemInfo(title: "개봉일자", selectMyItem: formatDateString(selectMyItem.openDate))
                                itemInfo(title: "제품명", selectMyItem: selectMyItem.itemName)
                                itemInfo(title: "추가설명", selectMyItem: selectMyItem.desc)
                            }
                            .padding()
                            .background(Color.white) // 카드 배경
                            .cornerRadius(16) // 둥근 모서리
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4) // 그림자
                            .padding(.horizontal)
                        } else {
                            Text("내 물건 정보를 선택하세요").padding(.horizontal).padding(.bottom)
                        }
                    }
                    
                    
                    Text("제목")
                        .padding(.horizontal)
                        .font(.headline)
                        .foregroundColor(.gray)
                    TextField("제목", text: $usedTitle)
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
                    
                    Text("가격")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    TextField("가격을 입력해주세요",  text: Binding(
                        get: { String(usedPrice) }, // Int를 String으로 변환
                        set: { usedPrice = Int($0) ?? 0 } // String을 Int로 변환
                    ))
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.white) // 카드 배경
                    .cornerRadius(16) // 둥근 모서리
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4) // 그림자
                    .padding(.horizontal)
                    
                    Text("자세한 설명")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    TextField("판매아이템에 대한 자세한 설명을 적어주세요", text: $usedContent)
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
                    
                    WideButton(title: "작성완료", backgroundColor: Color.btn) {
                        if usedTitle.isEmpty {
                            titleError = "제목을 입력해주세요."
                            titleIsFocused = true // 타이틀 필드로 포커스 이동
                            return
                        } else {
                            titleError = nil
                        }
                        if usedContent.isEmpty {
                            contentError = "내용을 입력해주세요."
                            contentIsFocused = true // 콘텐츠 필드로 포커스 이동
                            return
                        } else {
                            contentError = nil
                        }
                        usedVM.addUsed(selectedImages: selectedImages, usedTitle: usedTitle, usedPrice: usedPrice, usedContent: usedContent, selectMyItem: selectMyItem)
                        
                    }// true가되면 detailview를 보여주라
                }
            }.background(Color(UIColor.systemGroupedBackground))
        }
        .padding(.bottom, 20)
        .padding(.top, 20)
    }
    
    private func removeImage(at index: Int) {
        selectedImages.remove(at: index)
    }
    
    private func itemInfo(title:String,selectMyItem:String?) -> some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.secondary)
            Spacer()
            if let selectMyItem = selectMyItem {
                Text(selectMyItem.isEmpty ? "" : selectMyItem)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(10)
                    .frame(minWidth:250,alignment: .leading)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
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



#Preview {
    let used = UsedViewModel()
    UsedAddView().environmentObject(used)
    
}
