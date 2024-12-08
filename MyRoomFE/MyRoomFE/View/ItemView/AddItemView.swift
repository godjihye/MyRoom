//
//  AddItemView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/19/24.
//

import SwiftUI

struct AddItemView: View {
		@EnvironmentObject var itemVM: ItemViewModel
		@StateObject private var viewModel: ItemDetailsViewModel
		@Environment(\.dismiss) private var dismiss
		
		init(isEditMode: Bool = false, existingItem: Item? = nil, locationId: Int = 0) {
				_viewModel = StateObject(wrappedValue: ItemDetailsViewModel(existingItem: existingItem, isEditMode: isEditMode, locationId: locationId))
		}
		
		var body: some View {
				NavigationStack {
						Form {
								Section(header: Text("기본 정보")) {
										TextField("아이템 이름", text: $viewModel.itemName)
										TextField("아이템 설명", text: $viewModel.itemDesc)
										TextField("가격", text: $viewModel.itemPrice)
												.keyboardType(.decimalPad)
								}
						}
						.navigationTitle(viewModel.isEditMode ? "아이템 편집" : "새로운 아이템 추가")
						.toolbar {
								ToolbarItem(placement: .navigationBarTrailing) {
										Button("저장") {
												viewModel.saveItem(itemVM: itemVM)
												dismiss()
										}
										.disabled(viewModel.isSaveButtonDisabled)
								}
						}
				}
		}
}


#Preview {
	AddItemView().environmentObject(RoomViewModel())
}
