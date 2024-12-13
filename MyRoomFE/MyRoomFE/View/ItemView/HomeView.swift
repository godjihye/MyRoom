//
//  HomeView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI

struct HomeView: View {
	@EnvironmentObject var userVM: UserViewModel
	@State private var selectedTab: Int = 0
	@State private var isSearchActive: Bool = false
	
	var body: some View {
		NavigationStack {
			VStack(alignment: .center, spacing: 0) {
				VStack {
					if UserDefaults.standard.integer(forKey: "homeId") < 1 {
						enterHomeBtn
					}
					else {
						customToolBar
						tabbarView
						tabviews
						Spacer()
					}
				}
			}
			.navigationBarHidden(true)

			
//			.toolbar {
//				toolbarItems
//			}
		}
	}
	
	private var customToolBar: some View {
		HStack(spacing: 0) {
			Image("logo")
				.resizable()
				.frame(width: 45, height: 35)
			NavigationLink(destination: SearchView()) {
				SearchButton()
			}
			
			Button {
				
			} label: {
				Image(systemName: "square.and.arrow.up")
					.font(.system(size: 20))
			}
		}
		.padding(.top, -20)
		.padding(.horizontal)
	}
	private var enterHomeBtn: some View {
		VStack {
			Text("물건 정보를 저장하려면 집 등록을 해야합니다.")
				.font(.headline)
				.padding()
			NavigationLink(destination: EnterHomeView()) {
				Text("🏡 집 등록하기")
					.font(.system(size: 20))
					.bold()
			}
		}
		.padding(.top, -100)
	}
	private var tabbarView: some View {
		HStack(spacing: 0) {
			TabButton(title: "홈", isSelected: selectedTab == 0) {
				selectedTab = 0
			}
			TabButton(title: "즐겨찾기", isSelected: selectedTab == 1) {
				selectedTab = 1
			}
		}
	}
	private var tabviews: some View {
		TabView(selection: $selectedTab) {
			HomeListView()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.tag(0)
			FavListView()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.tag(1)
		}
	}
	private var toolbarItems: some ToolbarContent {
		Group {
			ToolbarItem(placement: .principal) {
				SearchButton()
//					NavigationLink(destination: SearchView()) {
//					SearchButton()
//				}
			}
			ToolbarItem(placement: .topBarLeading) {
				Button {
					userVM.logout()
				} label: {
					Image(systemName: "rectangle.portrait.and.arrow.right")
				}
			}
			ToolbarItem(placement: .topBarTrailing) {
				Button {
					
				} label: {
					Image(systemName: "square.and.arrow.up")
				}
			}
		}
		
	}
}

struct TabButton: View {
	let title: String
	let isSelected: Bool
	let action: () -> Void
	
	var body: some View {
		Button(action: action) {
			VStack {
				Text(title)
				Divider()
					.frame(height: 1)
					.background(isSelected ? .primary : .secondary)
			}
			.fontWeight(.bold)
			.frame(height: 35)
			.frame(maxWidth: .infinity)
			.foregroundColor(isSelected ? .primary : .secondary)
			.cornerRadius(8)
		}
	}
}
struct SearchButton: View {
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10)
				.frame(width: 280, height: 35)
				.foregroundStyle(Color(.systemGray5))
			HStack {
				Image(systemName: "magnifyingglass")
					.padding()
				Text("검색어를 입력하세요.")
					.foregroundStyle(Color(.systemGray2))
				Spacer()
			}
		}
		.padding()
		//.frame(height: 35)
	}
}
//#Preview {
//	let roomVM = RoomViewModel()
//	let itemVM = ItemViewModel()
//	let userVM = UserViewModel()
//	HomeView().environmentObject(roomVM).environmentObject(itemVM).environmentObject(userVM)
//}
#Preview {
	TabButton(title: "홈", isSelected: true) {
		
	}
}
