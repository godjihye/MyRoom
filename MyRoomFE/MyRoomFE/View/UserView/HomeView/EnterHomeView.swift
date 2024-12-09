//
//  EnterHomeView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/6/24.
//  User 중 homeId가 없으면 이 뷰로 온다.

import SwiftUI

struct EnterHomeView: View {
	var body: some View {
		NavigationStack {
			VStack(alignment: .leading) {
				Text("집 입장하기")
					.font(.largeTitle)
					.fontWeight(.bold)
				Spacer()
				VStack {
					NavigationLink(destination: JoinHomeView()) {
						WideButtonLabel(title: "초대 코드로 입장하기", backgroundColor: .accent)
					}
					NavigationLink(destination: MakeHomeView()) {
						WideButtonLabel(title: "새로 집 만들기", backgroundColor: .accent)
					}
				}
				Spacer()
				Text("")
			}
		}
		//			.frame(maxWidth: .infinity, maxHeight: .infinity)
		.padding()
	}
}
//
//#Preview {
//	EnterHomeView()
//}
