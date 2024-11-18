//
//  AddRoomView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI

struct AddRoomView: View {
		@Environment(\.dismiss) var dismiss
		@State private var roomName: String = ""
		@State private var roomDesc: String = ""
		let onSave: (String, String) -> Void

		var body: some View {
				NavigationView {
						Form {
								Section(header: Text("방 정보")) {
										TextField("방 이름(예: 안방)", text: $roomName)
										TextField("방을 설명해주세요.", text: $roomDesc)
								}
						}
						.navigationTitle("새로운 방 추가")
						.toolbar {
								ToolbarItem(placement: .confirmationAction) {
										Button("Save") {
												onSave(roomName, roomDesc)
												dismiss()
										}
								}
								ToolbarItem(placement: .cancellationAction) {
										Button("Cancel") {
												dismiss()
										}
								}
						}
				}
		}
}


#Preview {
	AddRoomView(){_, _ in
		
	}
}
