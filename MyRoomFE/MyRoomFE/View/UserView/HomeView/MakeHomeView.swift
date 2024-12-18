//
//  MakeHomeView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/5/24.
//

import SwiftUI

struct MakeHomeView: View {
	@Environment(\.dismiss) private var dismiss
	@EnvironmentObject var userVM: UserViewModel
	
	@State var homeName: String = ""
	@State var homeDesc: String = ""
	@State var isValidHomeName: Bool = true
	@State private var homeNameOffset: CGFloat = 0
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("집 생성하기")
				.font(.largeTitle)
				.fontWeight(.bold)
			
			VStack(alignment: .leading) {
				Text("집 이름 *")
					.fontWeight(.bold)
				CustomTextField(icon: "house.fill", placeholder: "집 이름을 입력해주세요.(필수)", text: $homeName)
				if !isValidHomeName {
					Text("집 이름 작성은 필수입니다.")
						.font(.footnote)
						.fontWeight(.bold)
						.foregroundStyle(.red)
						.offset(x: homeNameOffset)
						.onAppear(perform: {
							withAnimation(Animation.easeInOut(duration: 0.1)
								.repeatCount(10)) {
									self.homeNameOffset = -5
								}
						})
						.padding(.leading, 5)
				}
				Text("집 설명")
					.fontWeight(.bold)
				CustomTextField(icon: "house.fill", placeholder: "집 설명을 입력해주세요.(선택)", text: $homeDesc)
			}
			.padding(.vertical)
			WideButton(title: "저장", backgroundColor: .accent) {
				log("homeName.count: \(homeName.count)")
				if homeName.count > 1 {
					userVM.makeHome(homeName: homeName, homeDesc: homeDesc)
				} else {
					isValidHomeName = false
				}
			}
			.alert("집 등록", isPresented: $userVM.showAlert) {
				Button("확인", role: .cancel) {
					dismiss()
				}
			} message: {
				Text(userVM.message)
			}
		}
		.padding()
	}
}

#Preview {
	MakeHomeView()
}
