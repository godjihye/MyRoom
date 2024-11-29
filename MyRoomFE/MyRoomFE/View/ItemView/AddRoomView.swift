//
//  AddRoomView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI

struct AddRoomView: View {
	@Environment(\.dismiss) var dismiss
	var title: String = "새로운 방 추가"
	@State var roomName: String = ""
	@State var roomDesc: String = ""
	let onSave: (String, String) -> Void
	var body: some View {
		NavigationView {
			Form {
				Section(header: Text("방 정보")) {
					TextField("방 이름(예: 안방)", text: $roomName)
					TextField("방을 설명해주세요.", text: $roomDesc)
				}
			}
			.navigationTitle(title)
			.toolbar {
				ToolbarItem(placement: .confirmationAction) {
					Button("저장") {
						onSave(roomName, roomDesc)
						dismiss()
					}
				}
				if title == "새로운 방 추가" {
					ToolbarItem(placement: .cancellationAction) {
						Button("취소") {
							dismiss()
						}
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
