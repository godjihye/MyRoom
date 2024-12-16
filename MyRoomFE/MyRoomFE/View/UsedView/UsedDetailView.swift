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
    @Environment(\.dismiss) private var dismiss
    
    
    
    @Binding var used:Used
    let photos:[UsedPhotoData]
    let dateFormatter = DateFormatter().dateFormat
    
    @State private var selectedStatus: Int = 0
    
    @State private var isWebViewPresented = false
    @State private var selectedPhotoIndex: Int = 0
    @State private var isPhotoViewerPresented: Bool = false
    @State private var isShowingDeleteAlert = false
    @State private var isItemInfoPresented: Bool = false
    
    //채팅
    @EnvironmentObject var chatVM: ChatViewModel
    @State private var isChatViewPresented = false
    @State private var roomId: String?
    @State private var loginUser:String?
    @State private var usedUser:String?
    @State private var loginUserImg:String?
    @State private var usedUserImg:String?
    @State private var chatButtonName:String?
    
    
    let azuerTarget = Bundle.main.object(forInfoDictionaryKey: "AZURESTORAGE") as! String
    var loginUserId = UserDefaults.standard.integer(forKey: "userId")
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    usedImageTabView
                    infoView
                    usedStatusAndTitleView
                    
                    Button(action: {
                        isItemInfoPresented.toggle()
                    }) {
                        Text("판매자의 아이템 정보보기")
                            .font(.caption)
                            .foregroundColor(.accent)
                            .padding(.horizontal)
                        Spacer()
                    }
                    
                    usedContentView
                }
            }
            .navigationTitle("글 상세")
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxHeight: .infinity)
            .toolbar(content: {
                if self.loginUserId == used.user.id {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            NavigationLink("편집") {
                                UsedAddView(isEditMode: true, existingUsed: used)
                            }
                            Button("삭제") {
                                isShowingDeleteAlert = true
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                        .confirmationDialog(
                            "\(used.usedTitle)을/를 삭제하시겠습니까?",
                            isPresented: $isShowingDeleteAlert,
                            titleVisibility: .visible
                        ) {
                            Button("삭제", role: .destructive) {
                                usedVM.removeUsed(usedId: used.id)
                                dismiss()
                            }
                        }
                    }
                }
            })
            .onAppear {
                selectedStatus = used.usedStatus
                usedUser = used.user.nickname
                if let userImg = used.user.userImage {
                    usedUserImg = "\(azuerTarget)\(userImg)"
                } else {
                    usedUserImg = ""
                }
                if let loginImg = UserDefaults.standard.string(forKey: "userImage") {
                    loginUserImg = loginImg
                } else {
                    loginUserImg = ""
                }
                
                if self.loginUserId == used.user.id {
                    chatButtonName = "대화중인 채팅방"
                } else {
                    chatButtonName = "채팅하기"
                }
            }
            
            if isItemInfoPresented {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isItemInfoPresented = false // 팝업 닫기
                    }
                
                VStack {
                    itemInfoView
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                        .frame(maxWidth: 400)
                }
                .padding(40)
            }
        }
        UsedActionBarView
    }
    
    
    private var infoView: some View {
        VStack{
            HStack{
                let strURL = "\(azuerTarget)\(used.user.userImage ?? "")"
                if let url = URL(string: strURL) {
                    AsyncImage(url: url) {
                        image  in image.resizable().frame(width: 50, height: 50).clipShape(RoundedRectangle(cornerRadius: 50)).padding(.leading)
                    } placeholder: {
                        Image(systemName: "person.circle.fill").resizable().frame(width: 50, height: 50).clipShape(RoundedRectangle(cornerRadius: 50)).padding(.leading).foregroundColor(.blue)
                    }
                }
                VStack(alignment: .leading) {
                    Text(used.user.nickname)
                        .padding(.bottom,5)
                        .font(.headline)
                        .bold()
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
                        .background(.accent)
                        .cornerRadius(8)
                        .padding(.horizontal,10)
                        .sheet(isPresented: $isWebViewPresented) {
                            UsedWebView(url: URL(string: used.usedUrl ?? "")!)
                                .edgesIgnoringSafeArea(.all)
                        }
                }
            }
            Rectangle().frame(height: 1).foregroundColor(.gray).padding(.top, 0)
        }
    }
    
    private var usedStatusAndTitleView: some View {
        @ViewBuilder
        get {
            HStack(alignment: .center, spacing: 0) {
                if self.loginUserId == used.user.id {
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
                } else {
                    Text("\(statusText(for: used.usedStatus))")
                        .font(.headline)
                        .foregroundColor(color(for: used.usedStatus))
                        .padding()
                        .background(color(for: used.usedStatus).opacity(0.1))
                        .cornerRadius(8)
                }
                Text(used.usedTitle)
                    .padding(.horizontal)
                    .font(.title3)
                    .bold()
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var usedImageTabView:some View {
        TabView {
            ForEach(Array(photos.enumerated()), id: \.element) { index, photo in
                let strURL = "\(azuerTarget)\(photo.image)"
                if let url = URL(string: strURL) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 400, height: 300)
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
            .frame(height: 300)
            .sheet(isPresented: $isPhotoViewerPresented) {
                let photoURLs = photos.map { URL(string: "\(azuerTarget)\($0.image)")! }
                FullScreenImageView(imageURLs: photoURLs, selectedIndex: selectedPhotoIndex)
            }
    }
    
    private var itemInfoView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                if let itemName = used.itemName {
                    VStack(alignment: .leading) {
                        Text("제품명")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Text("\(itemName)")
                            .font(.footnote)
                            .foregroundColor(.black)
                            .bold()
                    }
                }
                
                if let purchasePrice = used.purchasePrice {
                    VStack(alignment: .leading) {
                        Text("구매가격")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Text("\(purchasePrice)원")
                            .font(.footnote)
                            .foregroundColor(.black)
                            .bold()
                    }
                }
                
                if let itemDesc = used.itemDesc {
                    VStack(alignment: .leading) {
                        Text("추가설명")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Text("\(itemDesc)")
                            .font(.footnote)
                            .foregroundColor(.black)
                            .bold()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading) // HStack 전체 왼쪽 정렬
            .padding(.horizontal)
            
            HStack(alignment: .top, spacing: 16) {
                if let usedPurchaseDate = used.usedPurchaseDate {
                    VStack(alignment: .leading) {
                        Text("구매일자")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Text("\(formatDateString(usedPurchaseDate))")
                            .font(.footnote)
                            .foregroundColor(.black)
                            .bold()
                    }
                }
                
                if let usedExpiryDate = used.usedExpiryDate {
                    VStack(alignment: .leading) {
                        Text("유통기한")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Text("\(formatDateString(usedExpiryDate))")
                            .font(.footnote)
                            .foregroundColor(.black)
                            .bold()
                    }
                }
                
                if let usedOpenDate = used.usedOpenDate {
                    VStack(alignment: .leading) {
                        Text("사용일자")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Text("\(formatDateString(usedOpenDate))")
                            .font(.footnote)
                            .foregroundColor(.black)
                            .bold()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading) // HStack 전체 왼쪽 정렬
            .padding(.horizontal)
        }
        .padding(.vertical, 10)
        .cornerRadius(8)
    }

    
    
    
    private var UsedActionBarView: some View {
        HStack(spacing: 20){
            
            //게시글 좋아요
            Button {
                used.isFavorite.toggle()
                Task{
                    await usedVM.toggleFavorite(userId: loginUserId, usedId: used.id, isFavorite: used.isFavorite)
                }
            } label: {
                Image(systemName: used.isFavorite ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(used.isFavorite ? .red : .gray)
            }
            .padding(.horizontal)
            
            //중고물품가격
            Text("\(used.usedPrice)").font(.title2)
            Spacer()
            
            //채팅하기
            Button {
                if let usedUser, let loginUser = UserDefaults.standard.string(forKey: "nickName") {
                    roomId = generateRoomId(user1: loginUser, user2: usedUser,usedTitle : used.usedTitle)
                    if let unwrappingRoomId = roomId {
                        chatVM.roomIdChk(roomId: unwrappingRoomId) { exist in
                            chatVM.createChatRoom(roomId: unwrappingRoomId, loginUser: loginUser, usedUser: usedUser,loginUserImg: loginUserImg ?? "",usedUserImg: usedUserImg ?? "", roomName: used.usedTitle)
                        }
                    }
                }
                isChatViewPresented.toggle()
            } label: {
                Text("\(chatButtonName ?? "" )")
            }.foregroundColor(.white)
                .padding(10)
                .background(.accent)
                .cornerRadius(8)
                .padding(.horizontal,10)
                .sheet(isPresented: $isChatViewPresented) {
                    if let roomId = roomId,
                       let usedUser = usedUser,
                       let loginUser = UserDefaults.standard.string(forKey: "nickName"){
                        if loginUserId == used.user.id {
                            ChatListView(chatUsedRoomName: used.usedTitle)
                        }else {
                            ChatView(roomId: roomId, loginUser: loginUser)
                        }
                    }
                }
        }
        .frame(height: 40)
    }
    
    private var usedContentView : some View {
        HStack {
            Text(used.usedDesc)
                .font(.body)
                .lineLimit(nil)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
    
    //상태별 텍스트 변경
    private func statusText(for status: Int) -> String {
        switch status {
        case 0:
            return "판매중"
        case 1:
            return "예약중"
        case 2:
            return "거래완료"
        default:
            return "상태 알 수 없음"
        }
    }
    
    // 상태별 색상 변경
    private func color(for status: Int) -> Color {
        switch status {
        case 0:
            return .green
        case 1:
            return .orange
        case 2:
            return .red
        default:
            return .gray
        }
    }
    
    
    //채팅방ID 생성
    func generateRoomId(user1: String, user2: String,usedTitle:String) -> String {
        let sortedIds = [usedTitle,user1, user2].sorted()
        let result = sortedIds.map { $0.replacingOccurrences(of: "[.\\#$\\[\\]]", with: "", options: .regularExpression) }.joined()
        print("generateRoomId completd : \(result)")
        
        return result
    }
    
}



//
//#Preview {
//		let used = UsedViewModel()
//		UsedDetailView(isFavorite:.constant(false), used: sampleUsed, photos: photoData).environmentObject(used)
////    UsedDetailView(used: userSample, photos: photoData)
//}
