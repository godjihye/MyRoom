//
//  HomeHeaderView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/19/24.
//

import SwiftUI

struct HomeHeaderView: View {
	@EnvironmentObject var itemVM: ItemViewModel
	@State private var query: String = ""
	@Binding var selectedTab: Int
	@Binding var tabHome: Bool
	@Binding var tabFav: Bool
	
	private let tabs = ["홈", "즐겨찾기"]
    var body: some View {
			NavigationStack {
				HStack(spacing: 0) {
					NavigationLink {
						SearchView()
					} label: {
						RoundedRectangle(cornerRadius: 10)
							.frame(width: 300, height: 30)
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
						withAnimation {
							selectedTab = 0
						}
						
						tabHome = true
						tabFav = false
					} label: {
						TabItemView(isActive: $tabHome, tab: tabs[0])
					}
					Button {
						withAnimation {
							selectedTab = 1
						}
						
						tabHome = false
						tabFav = true
					} label: {
						TabItemView(isActive: $tabFav, tab: tabs[1])
					}
				}
			}
    }
}

#Preview {
	HomeHeaderView(
		selectedTab: .constant(1),
		tabHome: .constant(false),
		tabFav: .constant(true)
	)
}

