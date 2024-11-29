//
//  AddLocationView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI

struct AddLocationView: View {
	@Environment(\.dismiss) var dismiss
	
	@State var locationName: String = ""
	@State var locationDesc: String = ""
	@State var selectedRoomId: Int = 0
	
	var title: String = "새로운 위치 추가"
	let rooms: [Room]
	let onSave: (Int, String, String) -> Void
	
	var body: some View {
		NavigationView {
			Form {
				Section(header: Text("방을 선택하세요!")) {
					Picker("방 선택하기", selection: $selectedRoomId) {
						ForEach(rooms) { room in
							Text(room.roomName).tag(room as Room?)
						}
					}
					.pickerStyle(MenuPickerStyle())
				}
				Section(header: Text("위치 정보")) {
					TextField("위치 이름(예: 화장대)", text: $locationName)
					TextField("위치를 설명해주세요", text: $locationDesc)
				}
			}
			.navigationTitle(title)
			.toolbar {
				ToolbarItem(placement: .confirmationAction) {
					Button("Save") {
						onSave(selectedRoomId, locationName, locationDesc)
						dismiss()
						
					}
				}
				if title == "새로운 위치 추가" {
					ToolbarItem(placement: .cancellationAction) {
						Button("Cancel") {
							dismiss()
						}
					}
				}
			}
		}
	}
}


#Preview {
	let roomVM = RoomViewModel()
	AddLocationView(rooms: roomVM.rooms, onSave: { room, locationName, locationDesc in
		print("add location")
	})
}
