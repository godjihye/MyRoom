//
//  UsedListView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//

import SwiftUI

struct UsedListView: View {
    @EnvironmentObject var usedVM:UsedViewModel
    @Binding var isFavorite:Bool
    var body: some View {
        
        NavigationSplitView {
            ScrollView{
                LazyVStack{
                    ForEach(usedVM.useds) { used in
                        NavigationLink {
//                            UsedDetailView( isFavorite: $isFavorite,used: used, photos: used.images)
                        } label: {
                            UsedRowView(used: used).padding(.horizontal)
                        }.onAppear {
                            if used == usedVM.useds.last {
                                usedVM.fetchUseds()
                            }
                        }
                    }.listStyle(.plain)
                     .navigationTitle("중고거래")
                      
                }.onAppear {
                    usedVM.fetchUseds()
                }.toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
//                            UsedAddView(title: "제목", price: 3000, content: "")
                        } label: {
                            Image(systemName: "plus.app")
                        }
                       }
                    ToolbarItem(placement: .topBarLeading) {
                        Button{
                            
                        } label: {
                            Image(systemName: "return")
                        }
                    }
                }
                
            }.alert("판매목록", isPresented: $usedVM.isFetchError) {
                Button("OK"){}
            } message: {
                Text(usedVM.message)
            }

        }detail: {
            Text("판매 목록")
        }
        
    }
}

#Preview {
    let used = UsedViewModel()
    UsedListView(isFavorite:.constant(false)).environmentObject(used)
}
