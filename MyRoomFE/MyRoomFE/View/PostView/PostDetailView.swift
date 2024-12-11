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
    
    @State var post:Post
    let photos:[PostPhotoData]
    
    @State private var isWebViewPresented = false
    @State private var selectedPhotoIndex: Int = 0
    @State private var isPhotoViewerPresented: Bool = false
    @State private var isPostWebViewPresented:Bool = false
    
    let azuerTarget = Bundle.main.object(forInfoDictionaryKey: "AZURESTORAGE") as! String
    var body: some View {
        ScrollView{
            VStack(spacing: 20) {
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
                                                    .fill(Color.blue)
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
                
                HStack{
                    let strURL = "\(azuerTarget)\(post.user.userImage ?? "")"
                    if let url = URL(string: strURL) {
                        AsyncImage(url: url) {
                            image  in image.resizable().frame(width: 50, height: 50).clipShape(RoundedRectangle(cornerRadius: 50)).padding(.leading)
                        } placeholder: {
                            Image(systemName: "person.circle.fill").frame(width: 50, height: 50).foregroundColor(.blue)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text(post.user.nickname).padding(.bottom,5)
                        HStack{
                            Text("관심 \(post.postFavCnt)").font(.caption).foregroundStyle(.gray)
                            Text("조회 \(post.postViewCnt)").font(.caption).foregroundStyle(.gray)
                        }
                    }
                    Spacer()
                    Button {
                        print("before : \(post.isFavorite)")
                        Task{
                            await postVM.toggleFavorite(postId: 4, userId: post.id, isFavorite: post.isFavorite) { success in
                                post.toggleFavorite()
                                post.isFavorite.toggle()
                                print("after : \(post.isFavorite)")
                            }
                            
                        }
                        
                    } label: {
                        Image(systemName: post.isFavorite ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(post.isFavorite ? .red : .gray)
                    }
                    .padding(.horizontal,20)
                    
                }
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)  // 선의 색상
                    .padding(.top, 0)
                
                HStack{
                    Text(post.postTitle).padding(.horizontal,10)
                    Spacer()
                }
                HStack {
                    Text(post.postContent).padding(.horizontal,10)
                }
                CommentListView(postId: post.id).environmentObject(CommentViewModel())
            }
        }.background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationTitle("글 상세")
            .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    let post = PostViewModel()
//    PostDetailView(post: samplePost, photos: postPhotoData).environmentObject(post)
//}
