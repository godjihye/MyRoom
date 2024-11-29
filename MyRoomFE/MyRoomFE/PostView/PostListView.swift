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
        NavigationSplitView{
            ScrollView{
//                LazyHStack{
//                    ForEach(postVM.posts) { post in
//                        NavigationLink {
//                            PostDetailView(post: post)
//                        } label: {
//                            PostRowView(post: post).padding(.horizontal)
//                        }
//                    }
//                }
            }
        }detail: {
            Text("상품정보입니다.")
        }
    }
}

#Preview {
    PostListView()
}
