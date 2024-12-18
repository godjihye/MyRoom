//
//  PostDetailView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//

import SwiftUI

//let postPhotoData = [PostPhotoData(id: 1, image: "test1.jpeg"),PostPhotoData(id: 2, image: "test2.jpeg")]

struct PostDetailView: View {
    @EnvironmentObject var postVM:PostViewModel
    @Environment(\.dismiss) private var dismiss
    
    @Binding var post:Post
    let photos:[PostPhotoData]
    
    @State private var isWebViewPresented = false
    @State private var selectedPhotoIndex: Int = 0
    @State private var isPhotoViewerPresented: Bool = false
    @State private var isPostWebViewPresented:Bool = false
    
    @State private var isShowingDeleteAlert = false
    
    let azuerTarget = Bundle.main.object(forInfoDictionaryKey: "AZURESTORAGE") as! String
    var loginUserId = UserDefaults.standard.integer(forKey: "userId")
    
    var body: some View {
        ScrollView{
            VStack(spacing: 20) {
                postImageTabSection
                postInfoSection
                postTitleSection
                postContentSection
            }
            CommentListView(postId: post.id).environmentObject(CommentViewModel())
        }
        .navigationTitle("글 상세")
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxHeight: .infinity)
        .toolbar(content: {
            if self.loginUserId == post.user.id {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        NavigationLink("편집") {
													test()
//                            PostAddView(isEditMode: true, existingUsed: post)
                        }
                        Button("삭제") {
                            isShowingDeleteAlert = true
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                    .confirmationDialog(
                        "\(post.postTitle)을/를 삭제하시겠습니까?",
                        isPresented: $isShowingDeleteAlert,
                        titleVisibility: .visible
                    ) {
                        Button("삭제", role: .destructive) {
                            postVM.removePost(postId: post.id)
                            dismiss()
                        }
                    }
                }
            }
        })
    }
    
    
    private var postImageTabSection : some View {
        TabView {
            ForEach(Array(photos.enumerated()), id: \.element) { index, photo in
                let strURL = "\(azuerTarget)\(photo.image)"
                
                if let url = URL(string: strURL) {
                    AsyncImage(url: url) { image in
                        ZStack {
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 400, height: 400)
                                .onTapGesture {
                                    selectedPhotoIndex = index
                                    isPhotoViewerPresented = true
                                }
                            
                            if let buttons = photo.btnData {
                                ForEach(buttons, id: \.self) { button in
                                    Button(action: {
                                        // 버튼을 클릭했을 때의 동작 (예: 버튼 URL 열기)
                                        isPostWebViewPresented.toggle()
                                    }) {
                                        Circle()
																				.fill(Color.accentColor)
                                            .frame(width: 20, height: 20)
                                            .overlay(
                                                Text("+")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 16))
                                            )
                                    }
                                    .position(x: button.positionX, y: button.positionY)
                                    .sheet(isPresented: $isPostWebViewPresented) {
                                        PostWebView(url: URL(string:  button.itemUrl ?? "")!)
                                            .edgesIgnoringSafeArea(.all)
                                    }
                                }
                            }
                        }
                    } placeholder: {
                        Image(systemName: "photo").resizable().frame(width: 200, height: 200)
                    }
                }
            }
        }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 400)
            .sheet(isPresented: $isPhotoViewerPresented) {
                let photoURLs = photos.map { URL(string: "\(azuerTarget)\($0.image)")! }
                FullScreenImageView(imageURLs: photoURLs, selectedIndex: selectedPhotoIndex)
            }
    }
    
    private var postInfoSection : some View {
        VStack{
            HStack{
                let strURL = "\(azuerTarget)\(post.user.userImage ?? "")"
                if let url = URL(string: strURL) {
                    AsyncImage(url: url) {
                        image  in image.resizable().frame(width: 50, height: 50).clipShape(RoundedRectangle(cornerRadius: 50)).padding(.leading)
                    } placeholder: {
                        Image(systemName: "person.circle.fill").resizable().frame(width: 50, height: 50).clipShape(RoundedRectangle(cornerRadius: 50)).padding(.leading).foregroundColor(.blue)
                    }
                }
                VStack(alignment: .leading) {
                    Text(post.user.nickname)
                        .padding(.bottom,5)
                        .font(.headline)
                        .bold()
                    HStack{
                        Text("관심 \(post.postFavCnt)").font(.caption).foregroundStyle(.gray)
                        Text("조회 \(post.postViewCnt)").font(.caption).foregroundStyle(.gray)
                    }
                }
                Spacer()
                
                Button {
                    post.isFavorite.toggle()
                    Task{
                        await postVM.toggleFavorite(postId: post.id, userId: loginUserId, isFavorite: post.isFavorite) { success in
                            
                        }
                    }
                } label: {
                    Image(systemName: post.isFavorite ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(post.isFavorite ? .red : .gray)
                }
                .padding(.horizontal,20)
                
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.top, 0)
        }
    }
    
    private var postTitleSection : some View {
        HStack(alignment: .center, spacing: 0){
            Text(post.postTitle)
                .padding(.horizontal)
                .font(.title3)
                .bold()
            Spacer()
        }.frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
    private var postContentSection : some View {
        HStack {
            Text(post.postContent)
                .font(.body)
                .lineLimit(nil)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//#Preview {
//    let post = PostViewModel()
//    PostDetailView(post: samplePost, photos: postPhotoData).environmentObject(post)
//}
