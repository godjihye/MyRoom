//
//  PostListView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/17/24.
//

import SwiftUI

struct PostListView: View {
    @EnvironmentObject var postVM: PostViewModel
    
    var body: some View {
        NavigationSplitView {
            postListContent
                .navigationTitle("커뮤니티")
                .refreshable {
                    await refreshPosts()
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        NavigationLink(destination: PostSearchView()) {
                            SearchButton()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        addPostButton
                    }
                }
        } detail: {
            Text("커뮤니티게시판")
        }
    }
    
}

// MARK: - Subviews
private extension PostListView {
    var postListContent: some View {
        ScrollView {
            LazyVStack {
                ForEach($postVM.posts.indices, id: \.self) { index in
                    postNavigationLink(for: postVM.posts[index])
                        .onAppear {
                            loadMorePostsIfNeeded(currentPost: postVM.posts[index])
                        }
                }
            }
            .task {
                await loadInitialPosts()
            }
        }
    }
    
    func postNavigationLink(for post: Post) -> some View {
        let postBinding = $postVM.posts[postVM.posts.firstIndex(where: { $0.id == post.id })!]
        
        return NavigationLink {
            PostDetailView(post: postBinding, photos: post.images)
                .task {
                    await postVM.updateViewCnt(postId: post.id)
                }
        } label: {
            PostRowView(post: post)
                .padding(.horizontal)
        }
    }
    
    var addPostButton: some View {
        NavigationLink {
            PostAddView().environmentObject(postVM)
        } label: {
            Image(systemName: "plus.app")
        }
    }
    
    struct SearchButton: View {
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 250, height: 35)
                    .foregroundStyle(Color(.systemGray5))
                HStack {
                    Image(systemName: "magnifyingglass")
                        .padding()
                    Text("검색어를 입력하세요.")
                        .foregroundStyle(Color(.systemGray2))
                    Spacer()
                }
            }
            //.frame(height: 35)
        }
    }
}

// MARK: - Helper Methods
private extension PostListView {
    func loadMorePostsIfNeeded(currentPost: Post) {
        Task {
            if currentPost == postVM.posts.last {
                await postVM.fetchPosts()
            }
        }
    }
    
    func loadInitialPosts() async {
        if postVM.posts.isEmpty {
            await postVM.fetchPosts()
        }
    }
    
    func refreshPosts() async {
        postVM.page = 1
        postVM.posts.removeAll()
        await postVM.fetchPosts()
    }
    
    
}

#Preview {
    let post = PostViewModel()
    PostListView().environmentObject(post)
}