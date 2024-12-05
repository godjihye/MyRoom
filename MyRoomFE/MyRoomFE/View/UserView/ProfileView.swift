//
//  ProfileView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/5/24.
//

import SwiftUI

struct ProfileView: View {
	@EnvironmentObject var userVM: UserViewModel
	let user = sampleUser
	var body: some View {
		
		GeometryReader { reader in
			ScrollView {
				Rectangle()
					.frame(height: reader.size.height / 3)
					.frame(maxWidth: .infinity)
					.foregroundStyle(.accent)
				if let userImage = user.userImage {
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
				}
				
				Text(user.nickname)
					.font(.title2)
					.bold()
				
				Label {
					Text(user.createdAt)
				} icon: {
					Text("가입일")
				}
				Label {
					Text(user.updatedAt)
				} icon: {
					Text("최근 수정일")
				}
				
				ProfileRow(user: sampleUser)
				
				
			}
		}
	}
}

#Preview {
	ProfileView()
}
