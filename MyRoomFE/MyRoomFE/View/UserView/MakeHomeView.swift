//
//  MakeHomeView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/5/24.
//

import SwiftUI

struct MakeHomeView: View {
	@State var homeName: String = ""
	@State var homeDesc: String = ""
	
    var body: some View {
			VStack {
				Text("집 생성하기")
					.font(.largeTitle)
					.fontWeight(.bold)
				HStack {
					Text("집 이름")
					CustomTextField(icon: "house.fill", placeholder: "집 이름을 입력해주세요.(필수)", text: $homeName)
				}
				HStack {
					Text("집 설명")
					CustomTextField(icon: "house.fill", placeholder: "집 설명을 입력해주세요.(선택)", text: $homeDesc)
				}
				WideButton(title: "저장", backgroundColor: .accent) {
					
				}
			}
			.padding()
    }
}

#Preview {
    MakeHomeView()
}
