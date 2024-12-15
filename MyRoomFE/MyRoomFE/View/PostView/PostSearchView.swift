//
//  SearchView.swift
//  MyRoomFE
//
//  Created by 이수정 on 12/15/24.
//

import SwiftUI


struct PostSearchView: View {
    @EnvironmentObject var postVM:PostViewModel
    @AppStorage("searchHistory") private var searchHistories: [String] = []
    @State private var query: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 50) {
                if postVM.searchResultPost.isEmpty {
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
                                            Task { await postVM.searchPost(query: searchHistories[index]) }
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
                            postVM.clearSearchResult()
                        } label: {
                            Text("검색 결과 초기화")
                        }
                    }
                    .padding(.bottom)
                    Divider()
                    ForEach($postVM.searchResultPost) { $post in
                        NavigationLink {
                            PostDetailView(post: $post, photos: post.images)
                        } label: {
                            PostRowView(post: post)
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    SearchBar(searchText: $query) {
                        Task { await postVM.searchPost(query: query) }
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
    PostSearchView().environmentObject(PostViewModel())
}
