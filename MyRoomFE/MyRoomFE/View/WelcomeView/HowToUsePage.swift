//
//  HowView.swift
//  Welcome
//
//  Created by jhshin on 12/10/24.
//

import SwiftUI

struct HowToUsePage: View {
	@Binding var isFirstLaunching: Bool
	var body: some View {
		VStack {
			Spacer()
			Text("마룸 사용 설명서")
				.font(.title)
				.bold()
				.foregroundStyle(.white)
				.opacity(0.8)
			FeatureCard(iconName: "1.circle.fill", title: "집을 등록해주세요.", description: "집을 등록하여 동거인을 초대할 수도 있어요.")
			FeatureCard(iconName: "2.circle.fill", title: "집 안의 방을 등록해주세요.", description: "예시) 거실, 침실, 주방")
			FeatureCard(iconName: "3.circle.fill", title: "방 안의 위치를 등록해주세요.", description: "예시) 책꽂이, 옷장, 상부장, 하부장")
			FeatureCard(iconName: "4.circle.fill", title: "물건을 등록해주세요.", description: "Tip) 텍스트가 있는 사진의 경우, 물건 등록이 더욱 쉬워요.")
			FeatureCard(iconName: "5.circle.fill", title: "물건의 사용설명서를 등록해주세요.", description: "Tip) 물건의 추가 사진의 경우 여러 장을 저장할 수 있어요")
			Spacer()
			Button {
				isFirstLaunching.toggle()
			} label: {
				Text("마룸 시작하기")
					.fontWeight(.bold)
					.foregroundStyle(.white)
					.padding(.bottom, 50)
			}

		}
		.padding()
	}
}

//#Preview {
//	HowToUsePage()
//}
