//
//  AddItemTextField.swift
//  MyRoomFE
//
//  Created by jhshin on 11/19/24.
//

import SwiftUI

struct AddItemTextField: View {
	var width: CGFloat
	var placeholder: String = ""
	@Binding var text: String
	
	var body: some View {
		TextField(placeholder, text: $text)
			.padding(.horizontal, 8) // 텍스트와 경계 사이 여백
			.frame(width: width, height: 25) // 지정된 너비와 높이
			.background(Color.gray.opacity(0.2)) // 배경 색상
			.cornerRadius(5) // 둥근 모서리
			.overlay(
				RoundedRectangle(cornerRadius: 5)
					.stroke(Color.gray, lineWidth: 1) // 테두리
			)
	}
}

#Preview {
	AddItemTextField(width: 200, placeholder: "Enter text", text: .constant(""))
}
