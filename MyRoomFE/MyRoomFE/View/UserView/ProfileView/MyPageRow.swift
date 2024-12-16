//
//  MyPageRow.swift
//  MyRoomFE
//
//  Created by jhshin on 12/12/24.
//

import SwiftUI

struct MyPageRow: View {
	let icon: String
	let title: String
	var backgroundColor: Color = Color.accentColor
	var body: some View {
		
		HStack {
			Text(icon)
				.font(.system(size: 16))
			Text(title)
				.font(.system(size: 16))
				.bold()
			Spacer()
			Image(systemName: "greaterthan")
				.renderingMode(.original)
		}
		.padding()
		.background {
			RoundedRectangle(cornerRadius: 10)
				.foregroundStyle(backgroundColor)
				.opacity(0.3)
		}
		.foregroundStyle(.black)
		.padding(.horizontal)
	}
}

#Preview {
	MyPageRow(icon: "🏠", title: "동거인 목록")
}
