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
		
		ScrollView {
			userInfoImage
			userInfoText
			editInfoBtn
			mateList
			logoutBtn
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
				.frame(height: 200)
				.frame(maxWidth: .infinity)
				.foregroundStyle(.accent)
			if let userImage = userVM.userInfo?.userImage {
				AsyncImage(url: URL(string: userImage.addingURLPrefix())) { image in
					image.image?.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: 150, height: 150)
						.clipShape(.circle)
						.overlay(Circle().stroke(.gray).opacity(0.8))
						.padding(.top, -100)
				}
			} else {
				Image(systemName: "person.circle.fill")
					.resizable()
					.frame(width: 150, height: 150)
					.aspectRatio(contentMode: .fill)
					.clipShape(.circle)
					.overlay(Circle().stroke(.gray).opacity(0.8))
					.padding(.top, -100)
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
					.foregroundStyle(.accent)
				
			}
		}
		.padding()
	}
	//MARK: - 프로필 수정 버튼
	private var editInfoBtn: some View {
		WideImageButton(title: "프로필 수정", backgroundColor: .gray) {
			showProfileEditView = true
		}
		.padding(.horizontal)
		.padding(.bottom)
	}
	//MARK: - Mate Users
	private var mateList: some View {
		VStack {
			Divider()
			Text("🏠 동거인 목록")
				.font(.title3)
				.bold()
				.padding()

			Button {
				userVM.getInviteCode()
				showInviteCode = true
			} label: {
				Text("동거인 추가하기")
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
					ProfileRow(mate: mate)
						.padding(.horizontal)
				}
			} else {
				Text("추가된 동거인이 없습니다.")
			}
		}
	}
	private var logoutBtn: some View {
		Button {
			userVM.logout()
		} label: {
			Text("로그아웃하기")
				.foregroundStyle(.gray)
		}
	}
}

#Preview {
	let userVM = UserViewModel()
	ProfileView().environmentObject(userVM)
}
