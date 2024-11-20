//
//  HomeHeaderView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/19/24.
//

import SwiftUI

struct HomeHeaderView: View {
	@Binding var query: String
	@Binding var selectedTab: Int
	@Binding var tabHome: Bool
	@Binding var tabFav: Bool
	
	private let tabs = ["홈", "즐겨찾기"]
    var body: some View {
			VStack(spacing: 20) {
				HStack(spacing: 0) {
					SearchBar(searchText: $query) {
						
					}
					Button {
						
					} label: {
						Image(systemName: "bell")
							.font(.system(size: 20))
							.bold()
					}
				}
				HStack(spacing:0) {
					Button {
						selectedTab = 0
					} label: {
						TabItemView(isActive: $tabHome, tab: tabs[0])
					}
					Button {
						selectedTab = 1
					} label: {
						TabItemView(isActive: $tabFav, tab: tabs[1])
					}
				}
			}
    }
}

#Preview {
	HomeHeaderView(
		query: .constant(""),
		selectedTab: .constant(1),
		tabHome: .constant(false),
		tabFav: .constant(true)
	)
}

