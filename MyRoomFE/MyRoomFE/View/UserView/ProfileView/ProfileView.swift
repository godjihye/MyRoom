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
						.overlay(Circle().stroke(Color.gray).opacity(0.8))
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
	
}
