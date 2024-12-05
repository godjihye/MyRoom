//
//  UsedListView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//

import SwiftUI

struct UsedListView: View {
    @EnvironmentObject var usedVM:UsedViewModel
    
    var body: some View {
        
        NavigationSplitView {
            ScrollView{
                LazyVStack{
                    ForEach($usedVM.useds) { $used in
                        NavigationLink() {
                            UsedDetailView(used: $used, photos: used.images)
                                .onAppear {
                                    Task{
                                        await usedVM.updateViewCnt(usedId: used.id)
                                    }
                                }
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
                            UsedAddView().environmentObject(usedVM)
                            
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
    UsedListView().environmentObject(used)
}
