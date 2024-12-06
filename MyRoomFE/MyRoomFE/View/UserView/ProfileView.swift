//
//  ProfileView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/5/24.
//

import SwiftUI

struct ProfileView: View {
	@EnvironmentObject var userVM: UserViewModel
	let userId = UserDefaults.standard.integer(forKey: "userId")
	//	let thumbnail: String? = UserDefaults.
	var body: some View {
		
		GeometryReader { reader in
			ScrollView {
				Rectangle()
					.frame(height: reader.size.height / 3)
					.frame(maxWidth: .infinity)
					.foregroundStyle(.accent)
				//FIXME: - User Image 등록
				if let userImage = userVM.userInfo?.userImage {
					AsyncImage(url: URL(string: userImage)) { image in
						image.image?.resizable()
							.frame(width: reader.size.height / 5, height: reader.size.height / 5)
							.aspectRatio(contentMode: .fill)
							.clipShape(.circle)
							.overlay(Circle().stroke(.gray).opacity(0.5))
							.padding(.top, -100)
					}
				} else {
					Image(systemName: "person")
						.resizable()
						.frame(width: reader.size.height / 5, height: reader.size.height / 5)
						.aspectRatio(contentMode: .fill)
						.clipShape(.circle)
						.overlay(Circle().stroke(.gray).opacity(0.5))
						.padding(.top, -100)
				}
				if let nickname = userVM.userInfo?.nickname {
					Text(nickname)
						.font(.title2)
						.bold()
				}
				if let createdAt = userVM.userInfo?.createdAt,
					 let updatedAt = userVM.userInfo?.updatedAt {
					Label {
						Text(createdAt)
					} icon: {
						Text("계정 생성일")
					}
					Label {
						Text(updatedAt)
					} icon: {
						Text("최근 수정일")
					}
				}
				
				ProfileRow(user: sampleUser)
				
				
			}
			.onAppear {
				if userVM.userInfo == nil {
					userVM.fetchUser()
				}
			}
		}
	}
}

#Preview {
	let userVM = UserViewModel()
	ProfileView().environmentObject(userVM)
}
