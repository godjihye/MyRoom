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
    
    var body: some View {
              
        VStack{
        if !itemVM.items.isEmpty{
                List(itemVM.items) { item in
                    NavigationView {
                               List(items, id: \.self) { item in
                                   Button(action: {
                                       print(item)
//                                         selectMyItem.append(contentsOf: items)
                                       dismiss()
                                   }) {
//                                        UsedItemRowView(item: item)
                                   }
                               }
                               .navigationTitle("내 아이템 선택")
                           }
                }
                .listStyle(.inset)
                .refreshable {
                    await itemVM.fetchItems(locationId: 1)
                }
            } else {
                Button("아이템이 없네요..."){
                    isShowingAddItemView = true
                }
                .padding(.top, 200)
            }
            Spacer()
        }.onAppear {
            await itemVM.fetchItems(locationId: 1)

        }
        
     
    
    }
}

#Preview {
    let itemVM = ItemViewModel()
    UsedItemListView().environmentObject(itemVM)
}
