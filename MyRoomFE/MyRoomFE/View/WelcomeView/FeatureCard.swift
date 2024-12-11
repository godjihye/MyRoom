//
//  FeatureCard.swift
//  Welcome
//
//  Created by jhshin on 12/10/24.
//

import SwiftUI

struct FeatureCard: View {
	let iconName: String
	let title: String
	let description: String
	var body: some View {
		HStack {
			Image(systemName: iconName)
				.font(.system(size: 30))
				.frame(width: 50)
			VStack(alignment: .leading) {
				Text(title)
					.font(.headline)
				Text(description)
					.font(.caption)
			}
			Spacer()
		}
		.padding()
		.background {
			RoundedRectangle(cornerRadius: 12)
				.foregroundStyle(.tint)
				.opacity(0.25)
				.brightness(-0.4)
		}
		.foregroundStyle(.white)
	}
}

#Preview {
	FeatureCard(iconName: "person", title: "물건 위치 관리", description: "집 안의 물건을 위치별로 목록화해 손쉽게 추적하고 관리할 수 있습니다.")

	FeatureCard(iconName: "person", title: "물건 정보 관리", description: "사용 설명서를 물리적으로 보관하는 대신 디지털로 안전하게 저장하세요.")

	FeatureCard(iconName: "person", title: "소통과 정보 공유", description: "정리 노하우부터 멋진 방 꾸미기 사진까지 다양한 정보와 아이디어를 공유하세요.")

	FeatureCard(iconName: "person", title: "중고거래 장소 제공", description: "저장한 물건 정보를 활용해 간편하게 중고거래 장소를 찾을 수 있습니다.")

}
