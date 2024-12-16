//
//  WideButton.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//

import SwiftUI

struct WideButton: View {
	var icon: String = ""
	var title: String
	var backgroundColor: Color
	var borderColor: Color = .clear
	var textColor: Color = .white
	var action: () -> Void = {}
	
	var body: some View {
		Button(action: action) {
			WideButtonLabel(icon: icon, title: title, backgroundColor: backgroundColor)
		}
		.padding(.horizontal)
	}
}

#Preview {
	WideButton(title: "작성완료", backgroundColor: Color.btn) {
		
	}
}
