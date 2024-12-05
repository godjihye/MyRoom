//
//  PostListView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/17/24.
//

import SwiftUI

struct PostListView: View {
    @EnvironmentObject var postVM:PostViewModel
    
    var body: some View {
        
        NavigationSplitView {
            ScrollView{
                LazyVStack {
                    ForEach(postVM.posts) { post in
                        NavigationLink {
                            PostDetailView(post: post, photos: post.images)
                                .onAppear {
                                    Task{
                                        await postVM.updateViewCnt(postId: post.id)
                                    }
                                }
                        } label: {
                            PostRowView(post: post)
                                .padding(.horizontal)
                        }.onAppear {
                            Task{
                                if post == postVM.posts.last {
                                    await postVM.fetchPosts()
                                }
                            }
                        }.listStyle(.plain)
                            .navigationTitle("커뮤니티")
                        
                    }
                }.onAppear {
                    Task{
                        await postVM.fetchPosts()
                    }
                }.toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            PostAddView().environmentObject(postVM)
                            
                        } label: {
                            Image(systemName: "plus.app")
                        }
                    }
                }
            }
        } detail: {
            Text("커뮤니티게시판")
        }

        
    }
}

#Preview {
    let post = PostViewModel()
    PostListView().environmentObject(post)
}
