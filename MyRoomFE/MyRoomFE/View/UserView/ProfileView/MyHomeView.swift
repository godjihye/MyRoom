//
//  MyHomeView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/18/24.
//
import SwiftUI

struct MyHomeView: View {
	@EnvironmentObject var userVM: UserViewModel
	@State private var isShowingAlert: Bool = false
	@State private var isShowingDeleteHomeAlert: Bool = false
	@State private var isShowingSheet: Bool = false
	@State private var message: String = ""
	@State private var homeNameInput: String = "" // 집 이름 변경 상태 변수
	@FocusState var showKeyboard: Bool
	let homeName: String = UserDefaults.standard.string(forKey: "homeName") ?? ""
	let userId: Int = UserDefaults.standard.integer(forKey: "userId")
	
	var body: some View {
		NavigationStack {
			ZStack {
				VStack {
					mateList
					outHome
				}
				.navigationTitle(homeName)
				.toolbar(content: {
					ToolbarItem(placement: .topBarTrailing) {
						Menu {
							editButton
							deleteButton
						} label: {
							Image(systemName: "ellipsis")
						}
					}
				})
				.alert("집 나가기 확인", isPresented: $isShowingAlert, actions: {
					Button("확인", role: .destructive) {
						userVM.deleteMate(userId: userId)
					}
					Button("취소", role: .cancel) { }
				}, message: { Text(message) })
				.alert("집 삭제 확인", isPresented: $isShowingDeleteHomeAlert, actions: {
					Button("확인", role: .destructive) {
						userVM.deleteHome()
					}
					Button("취소", role: .cancel) { }
				}, message: { Text(message) })
				
				// 어둡게 처리된 배경 및 이름 변경 시트
				if isShowingSheet {
					Color.black.opacity(0.5)
						.edgesIgnoringSafeArea(.all)
						.onTapGesture {
							isShowingSheet = false
						}
					
					VStack {
						Text("집 정보 수정")
							.font(.headline)
							.padding(.top, 20)
						
						TextField("새로운 집 이름", text: $homeNameInput)
							.textFieldStyle(RoundedBorderTextFieldStyle())
							.padding()
						
						Button(action: {
							userVM.editHome(homeNameInput)
							isShowingSheet = false
						}) {
							Text("저장")
								.bold()
								.frame(maxWidth: .infinity)
								.padding()
								.background(Color.accentColor)
								.foregroundColor(.white)
								.cornerRadius(10)
						}
						.padding([.leading, .trailing, .bottom], 20)
					}
					.frame(width: 300)
					.background(Color.white)
					.cornerRadius(10)
					.shadow(radius: 10)
					.onAppear {
						showKeyboard = true
					}
				}
			}
		}
	}
	
	// MARK: - Mate Users
	private var mateList: some View {
		VStack(alignment: .leading) {
			HStack {
				Text("동거인 목록 🏠")
					.font(.title)
					.bold()
					.padding()
				Spacer()
				NavigationLink(destination: InviteCodeView()) {
					Image(systemName: "person.fill.badge.plus")
						.renderingMode(.original)
						.font(.title3)
				}
			}
			.padding(.horizontal)
			Divider()
			
			if UserDefaults.standard.integer(forKey: "homeId") < 1 {
				Text("집을 먼저 등록해야 동거인 추가가 가능합니다.")
					.font(.headline)
					.foregroundStyle(.indigo)
					.padding(.bottom)
			} else {
				if let mates = userVM.userInfo?.mates {
					if mates.count > 1 {
						ForEach(mates) { mate in
							if mate.id != userId {
								ProfileRow(mate: mate)
									.padding(.horizontal)
							}
						}
					} else {
						VStack(alignment: .leading) {
							Text("추가된 동거인이 없습니다.😵‍💫")
								.padding(.bottom, 20)
							Text("상단 버튼을 눌러 초대코드를 통해 동거인을 초대하세요!")
						}
						.padding()
						.padding(.horizontal)
						Spacer()
					}
				}
			}
		}
	}
	
	private var outHome: some View {
		Button {
			isShowingAlert = true
			message = "정말 집을 나가시겠습니까?"
		} label: {
			Text("집에서 나가기")
				.foregroundStyle(.red)
				.padding()
		}
	}
	
	private var editButton: some View {
		Button("집 정보 편집") {
			isShowingSheet = true
		}
	}
	
	private var deleteButton: some View {
		Button("집 삭제") {
			isShowingDeleteHomeAlert = true
			message = "정말 집을 삭제하시겠습니까?"
		}
	}
}

#Preview {
	MyHomeView()
}
