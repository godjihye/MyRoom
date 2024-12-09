//
//  WideImageButton.swift
//  MyRoomFE
//
//  Created by jhshin on 11/29/24.
//

import SwiftUI

struct WideImageButton: View {
		var icon: String = ""
		var title: String
		var backgroundColor: Color
		var borderColor: Color = .clear
		var textColor: Color = .white
		var action: () -> Void
		
		var body: some View {
				Button(action: action) {
					WideButtonLabel(icon: icon, title: title, backgroundColor: backgroundColor)
				}
		}
}

#Preview {
		WideImageButton(icon: "person.badge.plus", title: "회원가입", backgroundColor: .gray) {
				
		}
		
		WideImageButton(icon: "person.badge.key", title: "로 그 인", backgroundColor: .gray) {
		
		}
}
