//
//  SearchBar.swift
//  MyRoom
//
//  Created by jhshin on 11/13/24.
//

import SwiftUI

struct SearchBar: View {
	@Binding var searchText: String
	@FocusState var showKeyboard: Bool
	var handler: ()->Void
	
	var body: some View {
		HStack {
			TextField("검색어를 입력하세요", text: $searchText)
				.focused($showKeyboard)
				.padding(.all, 10)
				.background(Color(.systemGray5))
				.clipShape(.rect(cornerRadius: 15))
				.padding(.horizontal, 10)
				.frame(width: 300)
				.onSubmit {
					handler()
				}
				.onAppear {
					showKeyboard = true
				}
				.textInputAutocapitalization(.none)
			
			Spacer()
		}
	}
}

#Preview {
	SearchBar(searchText: .constant("")) {
		
	}
}
