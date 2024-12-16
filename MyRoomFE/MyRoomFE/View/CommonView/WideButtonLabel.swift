//
//  WideButtonLabel.swift
//  MyRoomFE
//
//  Created by jhshin on 12/6/24.
//

import SwiftUI

struct WideButtonLabel: View {
	var icon: String = ""
	var title: String
	var backgroundColor: Color
	var borderColor: Color = .clear
	var textColor: Color = .white
	
	var body: some View {
		HStack {
			Image(systemName: icon)
				.foregroundColor(textColor)
			Text(title)
				.font(.headline)
				.foregroundColor(textColor)
		}
		.frame(height: 50)
		.frame(maxWidth: .infinity)
		//.padding()
		.background(backgroundColor)
		.cornerRadius(10)
		.overlay(
			RoundedRectangle(cornerRadius: 10)
				.stroke(borderColor, lineWidth: borderColor == .clear ? 0 : 1)
		)
	}
}
