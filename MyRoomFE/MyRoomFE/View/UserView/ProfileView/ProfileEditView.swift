//
//  ProfileEditView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/7/24.
//

import SwiftUI

struct ProfileEditView: View {
	
	@Environment(\.dismiss) private var dismiss
	@EnvironmentObject var userVM: UserViewModel
	
	@State private var isImageSourcePickerPresented: Bool = false
	@State private var isCamera: Bool = false
	@State private var isImagePickerPresented: Bool = false
	
	@State private var selectedThumbnail: UIImage?
	@State private var newNickname: String = ""
	
	var user: User
	
	init(user: User) {
		self.user = user
		_newNickname = State(initialValue: user.nickname)
	}
	
	var body: some View {
		NavigationView {
			VStack {
				profileImageView
				nicknameSection
				changePasswordLink
				Spacer()
				saveInfo
			}
			// .toolbar(content: toolbarItems)
			.sheet(isPresented: $isImagePickerPresented) {
				imagePickerView
			}
			.alert("회원정보 수정", isPresented: $userVM.showAlert, actions: {
				Button(role: .cancel) {
					dismiss()
				} label: {
					Text("확인")
				}
			}, message: {
				Text(userVM.message)
			})
			.padding()
		}
		.navigationTitle("프로필 수정")
		.navigationBarTitleDisplayMode(.inline)
	}
	
	// MARK: - Profile Image View
	private var profileImageView: some View {
		Button {
			isImageSourcePickerPresented = true
		} label: {
			if let thumbnail = selectedThumbnail {
				Image(uiImage: thumbnail)
					.resizable()
					.clipShape(Circle())
					.frame(width: 100, height: 100)
					.overlay(cameraIcon)
			} else {
				imageViewForUser
			}
		}
		.confirmationDialog("사진 소스 선택", isPresented: $isImageSourcePickerPresented, titleVisibility: .visible) {
			Button("포토 앨범") {
				isCamera = false
				isImagePickerPresented = true
			}
			Button("카메라") {
				isCamera = true
				isImagePickerPresented = true
			}
		}
	}
	
	private var imageViewForUser: some View {
		Group {
			if let userImageURL = user.userImage {
				AsyncImage(url: URL(string: userImageURL.addingURLPrefix())) { image in
					image.resizable()
						.clipShape(Circle())
						.frame(width: 100, height: 100)
						.overlay(cameraIcon)
				} placeholder: {
					ProgressView()
				}
			} else {
				Image(systemName: "person.circle.fill")
					.resizable()
					.clipShape(Circle())
					.frame(width: 100, height: 100)
					.overlay(cameraIcon)
			}
		}
	}
	
	private var cameraIcon: some View {
		Image(systemName: "camera")
			.resizable()
			.frame(width: 20, height: 20)
			.foregroundColor(.accentColor)
			.padding(9)
			.background(Color.white)
			.clipShape(Circle())
			.offset(x: 30, y: 30)
	}
	
	// MARK: - Nickname Section
	private var nicknameSection: some View {
		VStack {
			HStack {
				Text("닉네임")
					.fontWeight(.bold)
				Spacer()
			}
			CustomTextField(placeholder: "닉네임을 입력해주세요.", text: $newNickname)
			if newNickname.isEmpty {
				Text("닉네임을 입력해주세요!")
					.font(.footnote)
					.foregroundColor(.red)
			}
		}
	}
	
	// MARK: - Change Password Link
	private var changePasswordLink: some View {
		HStack {
			NavigationLink("비밀번호 변경") {
				ChangePWView()
			}
			Spacer()
		}
		.padding(.top)
	}
	
	// MARK: - Image Picker View
	private var imagePickerView: some View {
		Group {
			if isCamera {
				CameraPicker(image: $selectedThumbnail, sourceType: .camera)
			} else {
				ImagePicker(image: $selectedThumbnail)
			}
		}
	}
	
	// MARK: - Save Button
	private var saveInfo: some View {
		WideButton(title: "변경사항 저장", backgroundColor: .accent) {
			userVM.editUser(userImage: selectedThumbnail, nickname: newNickname == user.nickname ? nil : newNickname)
		}
	}
}

#Preview {
	ProfileEditView(user: sampleUser)
}
