//
//  ProfileView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/5/24.
//

import SwiftUI

struct ProfileView: View {
	@EnvironmentObject var userVM: UserViewModel
	@State private var showProfileEditView: Bool = false
	@State private var showInviteCode: Bool = false
	@State private var isCopySuccess: Bool = false
	let userId = UserDefaults.standard.integer(forKey: "userId")
	
	var body: some View {
		VStack {
			userInfoImage
			userInfoText
			//logoutBtn
		}
		.onAppear {
			if userVM.userInfo == nil {
				userVM.fetchUser()
			}
		}
		.fullScreenCover(isPresented: $showProfileEditView) {
			if let userInfo = userVM.userInfo {
				ProfileEditView(user: userInfo)
			}
		}
	}
	
	//MARK: - User Image
	private var userInfoImage: some View {
		Group {
			Rectangle()
				.frame(height: 270)
				.frame(maxWidth: .infinity)
				.foregroundStyle(.accent)
				.opacity(0.3)
				.offset(y: -70)
			if let userImage = userVM.userInfo?.userImage {
				AsyncImage(url: URL(string: userImage.addingURLPrefix())) { image in
					image.image?.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: 150, height: 150)
						.clipShape(.circle)
						.overlay(Circle().stroke(.gray).opacity(0.8))
						.padding(.top, -170)
				}
			} else {
				Image(systemName: "person.circle.fill")
					.resizable()
					.frame(width: 150, height: 150)
					.aspectRatio(contentMode: .fill)
					.clipShape(Circle())
					.overlay(Circle().stroke(Color.gray).opacity(0.8))
					.background(Circle().fill(Color.accent))
					.padding(.top, -170)
			}
		}
	}
	//MARK: - nickname, createdAt/updatedAt
	private var userInfoText: some View {
		VStack {
			if let nickname = userVM.userInfo?.nickname,
				 let userId = UserDefaults.standard.value(forKey: "userId"){
				
				HStack {
					Text(nickname)
						.font(.title2)
						.bold()
					Text("#\(userId)")
						.font(.footnote)
						.foregroundStyle(.secondary)
				}
			}
			
			if let createdAt = userVM.userInfo?.createdAt{
				
				Label {
					Text(createdAt.dateToString())
						.font(.footnote)
				} icon: {
					Text("가입일")
				}
				
				Text("마룸과 함께 한지 \(createdAt.datesSince()! + 1)일입니다.")
					.font(.footnote)
					.foregroundStyle(Color.myroom1)
				
			}
		}
		.padding(.top, -20)
		.padding(.bottom, 20)
	}
	//MARK: - Mate Users
	private var mateList: some View {
		VStack {
			Divider()
			Text("🏠 동거인 목록")
				.font(.title3)
				.bold()
				.padding()
			if UserDefaults.standard.integer(forKey: "homeId") > 0 {
				Button {
					userVM.getInviteCode()
					showInviteCode = true
				} label: {
					Text("동거인 추가하기")
						.padding(.bottom)
				}
			} else {
				Text("집을 먼저 등록해야 동거인 추가가 가능합니다.")
					.font(.headline)
					.foregroundStyle(.indigo)
					.padding(.bottom)
			}
			
			if showInviteCode && userVM.inviteCode != "" {
				HStack {
					Text("초대코드 \(userVM.inviteCode)")
						.fontWeight(.bold)
					Button {
						UIPasteboard.general.string = userVM.inviteCode
						isCopySuccess = UIPasteboard.general.hasStrings
					} label: {
						Text(isCopySuccess ? "복사완료" : "복사하기")
					}
					.foregroundStyle(isCopySuccess ? .red : .accent)
					.buttonStyle(.bordered)
					Button {
						userVM.refreshInviteCode()
					} label: {
						Text("코드 재발급")
					}
					.foregroundStyle(.secondary)
					.buttonStyle(.bordered)
				}
			}
			
			if let mates = userVM.userInfo?.mates {
				ForEach(mates) { mate in
					if mate.id != userId {
						ProfileRow(mate: mate)
							.padding(.horizontal)
					}
				}
			} else {
				Text("추가된 동거인이 없습니다.")
			}
		}
	}
	//MARK: - Chat List
	private var chatList:some View {
		
		VStack{
			Divider()
			NavigationLink(destination: ChatListView().environmentObject(ChatViewModel())) {
				Text("💬 채팅목록")
					.font(.title3)
					.bold()
					.padding()
			}
		}
	}
}

#Preview {
	let userVM = UserViewModel()
	ProfileView().environmentObject(userVM)
}
