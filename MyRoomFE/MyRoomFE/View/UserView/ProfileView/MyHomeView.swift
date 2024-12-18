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
	@State private var message: String = ""
	let homeName: String = UserDefaults.standard.string(forKey: "homeName") ?? ""
	let userId: Int = UserDefaults.standard.integer(forKey: "userId")
    var body: some View {
			NavigationStack {
				mateList
				outHome
			}
			.alert("집 나가기 확인", isPresented: $isShowingAlert, actions: {
				Button("확인", role: .destructive) {
					userVM.deleteMate(userId: userId)
				}
				Button("취소", role: .cancel) {
					
				}
			}, message: {
				Text(message)
			})
			.alert("집 삭제 확인", isPresented: $isShowingDeleteHomeAlert, actions: {
				Button("확인", role: .destructive) {
					userVM.deleteHome()
				}
				Button("취소", role: .cancel) {
					
				}
			}, message: {
				Text(message)
			})
			.alert("집 삭제 확인", isPresented: $userVM.showAlert, actions: {
				Button("확인", role: .destructive) {
					userVM.deleteHome()
				}
				Button("취소", role: .cancel) {
					
				}
			}, message: {
				Text(userVM.message)
			})
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
			.navigationTitle(homeName)
    }
	//MARK: - Mate Users
	private var mateList: some View {
		VStack {
			HStack {
				Text("")
				Spacer()
				Text("🏠 동거인 목록")
					.font(.title3)
					.bold()
					.padding()
				Spacer()
				NavigationLink(destination: InviteCodeView()) {
					Image(systemName: "person.fill.badge.plus")
						.renderingMode(.original)
				}
			}
			.padding(.horizontal)
			if UserDefaults.standard.integer(forKey: "homeId") < 1 {
				
				Text("집을 먼저 등록해야 동거인 추가가 가능합니다.")
					.font(.headline)
					.foregroundStyle(.indigo)
					.padding(.bottom)
			} else {
				
				
				List {
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
				.listStyle(.plain)
				
					
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
