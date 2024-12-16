//
//  ProfileRow.swift
//  MyRoomFE
//
//  Created by jhshin on 12/5/24.
//

import SwiftUI

struct ProfileRow: View {
	@EnvironmentObject var userVM: UserViewModel
	@State private var isShowingAlert: Bool = false
	@State private var message: String = ""
	@State private var deleteMateId: Int = 0
	var mate: MateUser?
	
	var body: some View {
		
		HStack {
			userThumbnail
			userNickname
			Spacer()
			userDeleteBtn
		}
		.alert("동거인 삭제", isPresented: $isShowingAlert) {
			Button("삭제", role: .destructive) {
				userVM.deleteMate(userId: deleteMateId)
			}
			Button("취소", role: .cancel) {
				
			}
		} message: {
			Text(message)
		}
		.alert("동거인 삭제", isPresented: $userVM.showAlert) {
			Button("확인", role: .cancel) {
				
			}
		} message: {
			Text(userVM.message)
		}
	}
	
	private var userThumbnail: some View {
		Group {
			if let userImage = mate?.userImage {
				AsyncImage(url: URL(string: userImage.addingURLPrefix())) { image in
					image.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: 60, height: 60)
						.clipShape(Circle())
				} placeholder: {
					ProgressView()
				}
			} else {
				Image(systemName: "person.circle.fill").resizable()
					.frame(width: 60, height: 60)
					.clipShape(Circle())
					.foregroundStyle(.accent)
					.opacity(0.6)
			}
		}
	}
	
	private var userNickname: some View {
		HStack {
			if let nickname = mate?.nickname, let id = mate?.id {
				Text(nickname)
					.bold()
				Text("#\(id)")
					.font(.footnote)
					.foregroundStyle(.secondary)
			}
		}
	}
	
	private var userDeleteBtn: some View {
		Button {
			message = "동거인 목록에서 삭제할까요?"
			if let id = mate?.id {
				deleteMateId = id
			}
			isShowingAlert = true
		} label: {
			Text("방출")
		}
	}
}

#Preview {
	ProfileRow(mate: MateUser(id: 1, userImage: nil, nickname: "마루미1"))
	ProfileRow(mate: MateUser(id: 2, userImage: nil, nickname: "마루미2"))
}
