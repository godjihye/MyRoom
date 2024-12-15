//
//  UsedSearchView.swift
//  MyRoomFE
//
//  Created by 이수정 on 12/15/24.
//

import SwiftUI

struct UsedSearchView: View {
    @EnvironmentObject var usedVM: UsedViewModel
    @AppStorage("searchHistory") private var searchHistories: [String] = []
    @State private var query: String = ""
    var body: some View {
        NavigationStack {
            VStack(spacing: 50) {
                if usedVM.searchResultUsed.isEmpty {
                    HStack {
                        Text("최근 검색어")
                            .fontWeight(.bold)
                        if searchHistories.isEmpty {
                            Text("최근 검색어 내역이 없습니다.")
                                .foregroundStyle(.gray)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(searchHistories.indices.reversed(), id: \.self) { index in
                                        Button {
                                            Task { await usedVM.searchUsed(query: searchHistories[index]) }
                                        } label: {
                                            HStack {
                                                Text(searchHistories[index])
                                                Button {
                                                    log("xmark btn clicked", trait: .info)
                                                    searchHistories.remove(at: index)
                                                } label: {
                                                    Image(systemName: "xmark")
                                                }
                                                
                                            }
                                            .padding(.all, 8)
                                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(.gray))
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                   
                } else {
                    HStack {
                        Text("검색 결과")
                        Button {
                            usedVM.clearSearchResult()
                        } label: {
                            Text("검색 결과 초기화")
                        }
                    }
                    .padding(.bottom)
                    Divider()
                    ForEach($usedVM.searchResultUsed) { $used in
                        NavigationLink {
                            UsedDetailView(used: $used, photos: used.images).environmentObject(ChatViewModel())
                        } label: {
                            UsedRowView(used: used)
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    SearchBar(searchText: $query) {
                        Task { await usedVM.searchUsed(query: query) }
                        if !searchHistories.contains(query){
                            searchHistories.append(query)
                        }
                    }
                    .onAppear(perform: UIApplication.shared.hideKeyboard)
                }
            }
        }
    }
}

#Preview {
    UsedSearchView()
}
