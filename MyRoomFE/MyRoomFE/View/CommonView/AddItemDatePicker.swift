//
//  AddItemDatePicker.swift
//  MyRoomFE
//
//  Created by jhshin on 11/20/24.
//

import SwiftUI

struct AddItemDatePicker: View {
	@State var date = Date()
    var body: some View {
			VStack {
				DatePicker("", selection: $date, displayedComponents: .date)
//					.padding(.horizontal, 8) // 텍스트와 경계 사이 여백
//					//.frame(width: 200, height: 25) // 지정된 너비와 높이
//					.foregroundStyle(Color.gray.opacity(0.2)) // 배경 색상
//					.cornerRadius(5) // 둥근 모서리
//					.overlay(
//						RoundedRectangle(cornerRadius: 5)
//							.stroke(Color.gray, lineWidth: 1) // 테두리
//					)
			}
    }
}

#Preview {
    AddItemDatePicker()
}
