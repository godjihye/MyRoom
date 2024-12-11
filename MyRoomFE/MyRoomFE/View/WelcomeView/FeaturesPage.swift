//
//  FeaturesPage.swift
//  Welcome
//
//  Created by jhshin on 12/10/24.
//

import SwiftUI

struct FeaturesPage: View {
	var body: some View {
		VStack {
			Text("마룸 앱의 특징")
				.font(.title)
				.fontWeight(.bold)
				.foregroundStyle(.white)
				.opacity(0.8)
			FeatureCard(iconName: "square.grid.3x3.topright.filled", title: "물건 위치 관리", description: "집 안의 물건을 위치별로 목록화해 손쉽게 추적하고 관리할 수 있습니다.")
			
			FeatureCard(iconName: "rectangle.fill.on.rectangle.fill", title: "물건 정보 관리", description: "사용 설명서를 물리적으로 보관하는 대신 디지털로 안전하게 저장하세요.")
			
			FeatureCard(iconName: "ellipsis.message.fill", title: "소통과 정보 공유", description: "정리 노하우부터 멋진 방 꾸미기 사진까지 다양한 정보와 아이디어를 공유하세요.")
			
			FeatureCard(iconName: "bubble.left.and.text.bubble.right.fill", title: "중고거래 장소 제공", description: "저장한 물건 정보를 활용해 간편하게 중고거래 장소를 찾을 수 있습니다.")
		}
		.padding()
	}
}

#Preview {
	FeaturesPage()
}


