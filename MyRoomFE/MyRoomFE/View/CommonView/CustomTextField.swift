//
//  CustomTextField.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI

struct CustomTextField:View {
		var icon: String
		var placeholder: String
	 
		@Binding var text: String
		var isSecured:Bool = false
		var body: some View {
				HStack {
						Image(systemName: icon)
								.foregroundColor(.gray)
						if isSecured {
								SecureField(placeholder, text: $text)
										.autocapitalization(.none)
										.disableAutocorrection(true)
										.textContentType(.none)
						} else {
								TextField(placeholder, text: $text)
										.autocapitalization(.none)
										.disableAutocorrection(true)
						}
				}
				.padding()
				.background(Color.gray.opacity(0.2))
				.cornerRadius(10)
				.overlay(
						RoundedRectangle(cornerRadius: 10)
								.stroke(Color.gray.opacity(0.5), lineWidth: 1)
				)
//				.padding(.horizontal)
		}
}

#Preview {
		CustomTextField(icon: "person.fill", placeholder: "사용자ID", text: .constant("wizard"))
		
		CustomTextField(icon: "lock.fill", placeholder: "비밀번호", text: .constant("1234"), isSecured: true)
}
