//
//  WideButton.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//

import SwiftUI

struct WideButton: View {
		
		var title: String
		var backgroundColor: Color
		var borderColor: Color = .clear
		var textColor: Color = .white
		var action: () -> Void
		
		var body: some View {
				Button(action: action) {
						HStack {
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
		WideButton(title: "작성완료", backgroundColor: Color.btn) {
				
		}
}
