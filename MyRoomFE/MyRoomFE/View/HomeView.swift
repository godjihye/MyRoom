//
//  HomeView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI

struct HomeView: View {
	@State private var showHeaderView: Bool = true
	@State private var selectedTab: Int = 0 {
		willSet {
			if newValue == 0 {
				tabHome = true
				tabFav = false
			} else {
				tabHome = false
				tabFav = true
			}
		}
	}
	@State private var tabHome: Bool = true
	@State private var tabFav: Bool = false
	@State private var query: String = ""
	private let tabs = ["홈", "즐겨찾기"]
	var body: some View {
		VStack(spacing: 20) {
			if showHeaderView {
				HomeHeaderView(query: $query, selectedTab: $selectedTab, tabHome: $tabHome, tabFav: $tabFav)
			}
			if selectedTab == 0 { HomeListView(showHeaderView: $showHeaderView) } else {
				FavListView(showHeaderView: $showHeaderView)
			}
		}
		.background(Color.backgroud)
	}
}

#Preview {
	let roomVM = RoomViewModel()
	let itemVM = ItemViewModel()
	HomeView().environmentObject(roomVM).environmentObject(itemVM)
}
