//
//  UsedItemListView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/28/24.
//

import SwiftUI

struct UsedItemListView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var itemVM: ItemViewModel
    @State var isShowingAddItemView: Bool = false
    
    @Binding var selectMyItem: Item?
    @Binding var isMyItemPresented:Bool
    var fetchAllItem:Bool
    
    @State var items: [Item] = []
    
    let columns = [
        GridItem(.flexible()), // 첫 번째 열
        GridItem(.flexible()), // 두 번째 열
        GridItem(.flexible())
    ]
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    if !self.items.isEmpty {
                        ForEach(self.items) { item in
                            UsedItemRowView(selectedItem: $selectMyItem,
                                            isMyItemPresented: $isMyItemPresented,
                                            item: item)
                        }
                        
                    } else {
                        noItemsView
                    }
                }
                .onAppear {
                    Task {
                        self.items =  await itemVM.fetchAllItem(filterByItemUrl: fetchAllItem)
                    }
                }
                
            }
            
        }
        .padding()
    }
    
    private var noItemsView: some View {
        Text("아이템이 없네요...")
            .padding(.top, 200)
    }
}

//#Preview {
//    let itemVM = ItemViewModel()
//    UsedItemListView(selectMyItem:.constant(sampleItem), postIsMyItemPresented: .constant(true), usedIsMyItemPresented: .constant(true)).environmentObject(itemVM).environmentObject(PostViewModel())
//}
