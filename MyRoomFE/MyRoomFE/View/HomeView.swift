//
//  HomeView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI

struct HomeView: View {
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
			CustomTextField(icon: "magnifyingglass", placeholder: "검색어를 입력하세요", text: $query)
			HStack(spacing:0) {
				Button {
					withAnimation {
						selectedTab = 0
					}
				} label: {
					TabItemView(isActive: $tabHome, tab: tabs[0])
				}
				Button {
					withAnimation{
						selectedTab = 1
					}
				} label: {
					TabItemView(isActive: $tabFav, tab: tabs[1])
				}
			}
			TabView(selection: $selectedTab) {
				
				HomeListView().tag(0)
				FavListView().tag(1)
				
					.toolbar(.hidden, for: .tabBar)
			}
			.tabViewStyle(.page(indexDisplayMode: .automatic))
		}
		.background(Color.backgroud)
	}
}

#Preview {
	let roomVM = RoomViewModel()
	let itemVM = ItemViewModel()
	HomeView().environmentObject(roomVM).environmentObject(itemVM)
}
