//
//  WideImageButton.swift
//  MyRoomFE
//
//  Created by jhshin on 11/29/24.
//

import SwiftUI

struct WideImageButton: View {
		var icon: String
		var title: String
		var backgroundColor: Color
		var borderColor: Color = .clear
		var textColor: Color = .white
		var action: () -> Void
		
		var body: some View {
				Button(action: action) {
						HStack {
								Image(systemName: icon)
										.foregroundColor(textColor)
								
								Text(title)
										.font(.headline)
										.foregroundColor(textColor)
						}
						.frame(maxWidth: .infinity)
						.padding()
						.background(backgroundColor)
						.cornerRadius(10)
						.overlay(
								RoundedRectangle(cornerRadius: 10)
										.stroke(borderColor, lineWidth: borderColor == .clear ? 0 : 1)
						)
				}
		}
}

#Preview {
		WideImageButton(icon: "person.badge.plus", title: "회원가입", backgroundColor: .gray) {
				
		}
		
		WideImageButton(icon: "person.badge.key", title: "로 그 인", backgroundColor: .gray) {
		
		}
}
