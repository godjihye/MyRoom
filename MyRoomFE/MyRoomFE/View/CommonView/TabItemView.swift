//
//  TabItemView.swift
//  InMyRoom
//
//  Created by jhshin on 11/13/24.
//

import SwiftUI

struct TabItemView: View {
	@Binding var isActive: Bool
	@State var tab: String
	var body: some View {
		VStack {
			Text(tab)
				.foregroundStyle(isActive ? .accent : .gray)
				.fontWeight(isActive ? .bold : .regular)
			Divider()
				.background(isActive ? .accent : .gray)
		}
	}
}

#Preview {
	TabItemView(isActive: .constant(true), tab: "즐겨찾기")
}
