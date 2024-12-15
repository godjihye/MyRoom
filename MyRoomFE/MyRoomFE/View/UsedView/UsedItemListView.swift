//
//  UsedItemListView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/28/24.
//

import SwiftUI
//let items: Item? =
//    Item(
//                id: 1,
//                itemName: "아이폰 13",
//                purchaseDate: "2023-11-15",
//                expiryDate: "2024-11-15",
//                url: "https://example.com/item/1",
//                photo: "iphone_13_image",
//                desc: "상태 좋은 아이폰 13, 128GB, 흰색",
//                color: "흰색",
//                isFav: true,
//                price: 550000,
//                openDate: "2023-11-15",
//                locationId: 101,
//                createdAt: "2023-11-15",
//                updatedAt: "2023-12-01",
//                itemPhotos: [
//                    ItemPhoto(id: 1, photo: "https://example.com/images/iphone_13_1.jpg"),
//                    ItemPhoto(id: 2, photo: "https://example.com/images/iphone_13_2.jpg")
//                ],
//                location: MyRoomFE.Item_Location(locationName: "화장대", room: MyRoomFE.Item_Room(roomName: "jh")))
struct UsedItemListView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var itemVM: ItemViewModel
    @State var isShowingAddItemView: Bool = false
    
    @Binding var selectMyItem: Item?
    @Binding var isMyItemPresented:Bool
    var fetchAllItem:Bool
    @State private var isLoading = true
    
    let columns = [
        GridItem(.flexible()), // 첫 번째 열
        GridItem(.flexible()), // 두 번째 열
        GridItem(.flexible())
    ]
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    if isLoading {
                        // 데이터가 로딩 중일 때 보여줄 로딩 뷰
                        Text("로딩 중...")
                    } else {
                        // 데이터가 로딩된 후 항목 표시
                        ForEach(itemVM.items) { item in
                            UsedItemRowView(selectedItem: $selectMyItem,
                                            isMyItemPresented: $isMyItemPresented,
                                            item: item)
                            .environmentObject(itemVM)
                        }
                    }
                }
                .onAppear {
                    // 뷰가 나타날 때 fetchAllItem 호출하여 데이터를 가져옵니다.
                    Task {
                        await itemVM.fetchAllItem(filterByItemUrl: fetchAllItem)
                        isLoading = false
                        print("itemVM.items : \(itemVM.items)")
                    }
                }
                
            }
            
        }
        .padding()
    }
}

//#Preview {
//    let itemVM = ItemViewModel()
//    UsedItemListView(selectMyItem:.constant(sampleItem), postIsMyItemPresented: .constant(true), usedIsMyItemPresented: .constant(true)).environmentObject(itemVM).environmentObject(PostViewModel())
//}
