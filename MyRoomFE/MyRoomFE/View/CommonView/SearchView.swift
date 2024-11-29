//
//  SearchView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/27/24.
//

import SwiftUI

struct SearchView: View {
	@EnvironmentObject var itemVM: ItemViewModel
	@AppStorage("searchHistory") private var searchHistories: [String] = []
	@State private var query: String = ""
	
	var body: some View {
		NavigationStack {
			VStack(spacing: 50) {
				if itemVM.searchResultItems.isEmpty {
					HStack {
						Text("최근 검색어")
							.fontWeight(.bold)
						if searchHistories.isEmpty {
							Text("최근 검색어 내역이 없습니다.")
								.foregroundStyle(.gray)
						} else {
							ScrollView(.horizontal, showsIndicators: false) {
								HStack {
									ForEach(searchHistories.indices.reversed(), id: \.self) { index in
										Button {
											Task { await itemVM.searchItem(query: searchHistories[index]) }
										} label: {
											HStack {
												Text(searchHistories[index])
												Button {
													log("xmark btn clicked", trait: .info)
													searchHistories.remove(at: index)
												} label: {
													Image(systemName: "xmark")
												}

											}
											.padding(.all, 8)
											.overlay(RoundedRectangle(cornerRadius: 20).stroke(.gray))
										}
									}
								}
							}
						}
						Spacer()
					}
					//TODO: mic button action
					Button {
						
					} label: {
						Circle().fill(.accent)
							.overlay(
								Image(systemName: "mic")
									.font(.system(size: 144))
									.foregroundStyle(.white)
							)
					}
					.padding()
				} else {
					HStack {
						Text("검색 결과")
						Button {
							itemVM.clearSearchResult()
						} label: {
							Text("검색 결과 초기화")
						}
					}
					.padding(.bottom)
					Divider()
					ForEach(itemVM.searchResultItems) { item in
						NavigationLink {
							ItemDetailView(item: item)
						} label: {
							ItemRowView(item: item, isSearch: true)
						}
					}
				}
				Spacer()
			}
			.padding(.horizontal)
			.toolbar {
				ToolbarItem(placement: .principal) {
					SearchBar(searchText: $query) {
						Task { await itemVM.searchItem(query: query) }
						if !searchHistories.contains(query){
							searchHistories.append(query)
						}
					}
					.onAppear(perform: UIApplication.shared.hideKeyboard)
				}
			}
		}
	}
}

#Preview {
	let itemVM = ItemViewModel()
	SearchView().environmentObject(itemVM)
}
