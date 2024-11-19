//
//  SearchBar.swift
//  InMyRoom
//
//  Created by jhshin on 11/13/24.
//

import SwiftUI

struct SearchBar: View {
	@Binding var searchText: String
	@State var isEditing = false
	var handler: ()->Void
	var body: some View {
		HStack {
			TextField("🔍 검색어를 입력하세요", text: $searchText)
				.padding(.all, 10)
				.background(Color(.systemGray5))
				.clipShape(.rect(cornerRadius: 15))
				.padding(.horizontal, 10)
				.frame(width: 350)
				.onSubmit {
					handler()
				}
				.onTapGesture {
					isEditing = true
				}.animation(.easeInOut, value: isEditing)
				.textInputAutocapitalization(.none)
			//focus가 오면 isEditing을 활성화해줘야함.
			
			if isEditing {
				Button {
					isEditing = false
					print("btn clicked")
				} label: {
					Text("Cancel")
				}
				.padding(.trailing, 15)
				.transition(.move(edge: .trailing))
			}
		}
	}
}

#Preview {
	SearchBar(searchText: .constant("")) {
		
	}
}
