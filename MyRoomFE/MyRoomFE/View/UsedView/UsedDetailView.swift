//
//  UsedDetailView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//
import Foundation
import SwiftUI
import WebKit

let photoData = [UsedPhotoData(id: 1, image: "test1.jpeg"),UsedPhotoData(id: 2, image: "test2.jpeg")]

struct UsedDetailView: View {
    @EnvironmentObject var usedVM: UsedViewModel
//    @State var isFavorite:Bool
    
    @Binding var used:Used
    let photos:[UsedPhotoData]
    let dateFormatter = DateFormatter().dateFormat
    
    @State private var selectedStatus: Int = 0
    
    @State private var isWebViewPresented = false
    @State private var selectedPhotoIndex: Int = 0
    @State private var isPhotoViewerPresented: Bool = false
    
    @StateObject private var chatVM = ChatViewModel()
    @State private var isChatViewPresented = false
    @State private var roomId: String?
    @State private var loginUser:String?
    @State private var usedUser:String?
    @State private var loginUserImg:String?
    @State private var usedUserImg:String?
    
    
    let azuerTarget = Bundle.main.object(forInfoDictionaryKey: "AZURESTORAGE") as! String
    let userId = 4
    
    var body: some View {
            
            ScrollView{
                VStack(spacing: 20) {
                    TabView {
                        ForEach(Array(photos.enumerated()), id: \.element) { index, photo in
                            let strURL = "\(azuerTarget)\(photo.image)"
                            if let url = URL(string: strURL) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 400, height: 400)
                                        .onTapGesture {
                                            selectedPhotoIndex = index
                                            isPhotoViewerPresented = true
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
                        let strURL = "\(azuerTarget)\(used.user.userImage ?? "")"
                        if let url = URL(string: strURL) {
                            AsyncImage(url: url) {
                                image  in image.resizable().frame(width: 50, height: 50).clipShape(RoundedRectangle(cornerRadius: 50)).padding(.leading)
                            } placeholder: {
                                Image(systemName: "person.circle.fill").frame(width: 50, height: 50).foregroundColor(.blue)
                            }
                        }
                        VStack(alignment: .leading) {
                            Text(used.user.nickname).padding(.bottom,5)
                            HStack{
                                Text("관심 \(used.usedFavCnt)").font(.caption).foregroundStyle(.gray)
                                Text("채팅 \(used.usedChatCnt)").font(.caption).foregroundStyle(.gray)
                                Text("조회 \(used.usedViewCnt)").font(.caption).foregroundStyle(.gray)
                            }
                        }
                        Spacer()
                        
                        if let usedUrl = used.usedUrl {
                            Button {
                                isWebViewPresented.toggle()
                            } label: {
                                Text("쇼핑몰로 가기")
                            }.foregroundColor(.white)
                                .padding(10)
                                .background(Color.btn)
                                .cornerRadius(8)
                                .padding(.horizontal,10)
                                .sheet(isPresented: $isWebViewPresented) {
                                    UsedWebView(url: URL(string: used.usedUrl ?? "")!)
                                        .edgesIgnoringSafeArea(.all)
                                }
                        }
                    }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .padding(.top, 0)
                    
                    HStack{
                        Text(used.usedTitle).padding(.horizontal,10)
                        Spacer()
                    }
                    Divider()
                    HStack {
                        Picker("상태", selection: $selectedStatus) {
                            Text("판매중").tag(0) // 값 0
                            Text("예약중").tag(1) // 값 1
                            Text("거래완료").tag(2) // 값 2
                        }
                        .pickerStyle(.automatic)
                        .padding(.horizontal)
                        .onChange(of: selectedStatus) { newValue in
                            Task {
                                print(newValue)
                                await usedVM.updateUsedStatus(usedStatus: newValue, usedId: used.id)
                            }
                        }
                        Spacer()
                    }
                    HStack{
                        VStack{
                            if let purchasePrice = used.purchasePrice { Text("구매가격 : \(used.purchasePrice ?? 0)") }
                            if let usedPurchaseDate = used.usedPurchaseDate {Text("구매일자 : \(formatDateString(used.usedPurchaseDate ?? ""))")}
                        }
                        VStack{
                            if let usedExpiryDate = used.usedExpiryDate { Text("유통기한 : \(formatDateString(used.usedExpiryDate ?? ""))")}
                            if let usedOpenDate = used.usedOpenDate { Text("사용시작일자 : \(formatDateString(used.usedOpenDate ?? ""))")}
                        }
                    }
                    Divider()
                    HStack {
                        Text(used.usedDesc).padding(.horizontal,10)
                    }
                    
                }
            }.background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
                .navigationTitle("글 상세")
                .navigationBarTitleDisplayMode(.inline)
                .frame(maxHeight: .infinity)
                .onAppear {
                    selectedStatus = used.usedStatus
                    usedUser  = used.user.nickname
                    loginUser = "soojeong"
                    if let userImg = used.user.userImage {
                        usedUserImg = "\(azuerTarget)\(userImg)"
                    }else {
                        usedUserImg = ""
                    }
                    loginUserImg = ""
                    
                }
            HStack(spacing: 20){
                Button {
                    print("before : \(used.isFavorite)")
    //                used.isFavorite.toggle()
                    usedVM.toggleFavorite(userId: 4, usedId: used.id, isFavorite: used.isFavorite) { success in
                        if success {
                           
                        }
    //                    print("after : \(used.isFavorite)")
    //
                    }
                    
                    
                } label: {
                    Image(systemName: used.isFavorite ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(used.isFavorite ? .red : .gray)
                }
                .padding(.horizontal)
                Text("\(used.usedPrice)").font(.title2)
                Spacer()
                Button {
                    if let loginUser,
                       let usedUser,
                       let loginUserImg,
                       let usedUserImg {
                        roomId = generateRoomId(user1: loginUser, user2: usedUser)
                        if let unwrappedRoomId = roomId {
                            chatVM.createChatRoom(roomId: unwrappedRoomId, loginUser: loginUser, usedUser: usedUser,loginUserImg: loginUserImg,usedUserImg: usedUserImg, roomName: used.usedTitle)
                        }
                    }
                    isChatViewPresented.toggle()
                } label: {
                    Text("채팅하기")
                }.foregroundColor(.white)
                    .padding(10)
                    .background(Color.btn)
                    .cornerRadius(8)
                    .padding(.horizontal,10)
                    .sheet(isPresented: $isChatViewPresented) {
                        if let roomId = roomId,
                           let loginUser = loginUser,
                           let usedUser = usedUser {
                            ChatView(roomId: roomId, loginUser: loginUser, usedUser: usedUser).environmentObject(chatVM)
                        }
                    }
            }
            .frame(height: 40)
        }
        
        func formatDateString(_ dateString: String?) -> String {
            
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd"
            
            
            if let dateString = dateString,
               let date = inputFormatter.date(from: dateString) {
                return outputFormatter.string(from: date)
            }
            return "Invalid Date"
        }
        
        //채팅방ID 생성
        func generateRoomId(user1: String, user2: String) -> String {
            let sortedIds = [user1, user2].sorted()
            return sortedIds.joined(separator: "_")
        }
        
    }




#Preview {
    let used = UsedViewModel()
//    UsedDetailView( used: userSample, photos: photoData).environmentObject(used)
    //    UsedDetailView(used: userSample, photos: photoData)
}
