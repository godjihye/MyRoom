//
//  SearchView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/27/24.
//

import SwiftUI

struct SearchView: View {
	@Environment(\.dismiss) private var dismiss
	@EnvironmentObject var itemVM: ItemViewModel
	@AppStorage("searchHistory") private var searchHistories: [String] = []
	@FocusState private var showKeyboard: Bool
	@State private var query: String = ""
	
	var body: some View {
		NavigationStack {
			VStack(alignment: .leading) {
				customToolBar
				if itemVM.searchResultItems.isEmpty {
					SearchHistoryView(
						searchHistories: $searchHistories,
						query: $query,
						onSearch: { query in
							itemVM.searchItem(query: query)
						},
						onDelete: { index in
							searchHistories.remove(at: index)
						}
					)
				} else {
					SearchResultsView(combinedItems: $itemVM.searchResultItems, itemsByName: $itemVM.searchResultItemsByName, itemsByImageText: $itemVM.searchResultItemsByImageText,items: itemVM.searchResultItems, onClear: itemVM.clearSearchResult)
						.onAppear {
							showKeyboard = false
						}
				}
				Spacer()
			}
			.padding(.top)
			.padding(.horizontal)
			.onAppear{
				DispatchQueue.main.async {
					showKeyboard = true
				}
			}
			.alert("아이템 검색 결과", isPresented: $itemVM.isShowingAlert) {
				Button("확인", role: .none){}
			} message: {
				Text(itemVM.message)
			}
		}
		.navigationBarBackButtonHidden()
	}
	private var customToolBar: some View {
		GeometryReader { reader in
			HStack(spacing: 0) {
				Button {
					dismiss()
				} label: {
					Image(systemName: "chevron.left") // 화살표 Image
						.font(.system(size: 25))
				}
				.padding(0)
				
				Spacer()
				TextField("검색어를 입력하세요", text: $query)
					.font(.system(size: 15))
					.padding(10)
					.background(Color(.systemGray6))
					.clipShape(RoundedRectangle(cornerRadius: 10))
					.frame(width: reader.size.width - 70)
					.focused($showKeyboard)
					.overlay(
						Image(systemName: query.isEmpty ? "" : "xmark.circle.fill")
							.foregroundStyle(.secondary)
							.padding(.trailing, 10)
							.onTapGesture {
								query = ""
							},
						alignment: .trailing
					)
					.onSubmit {
						itemVM.searchItem(query: query)
						if !searchHistories.contains(query) {
							searchHistories.append(query)
						}
					}
					.onAppear {
						UIApplication.shared.hideKeyboard()
					}
				Button {
					dismiss()
				} label: {
					Text("취소")
						.font(.system(size: 15))
						.foregroundStyle(.black)
				}
				.padding(0)
				.frame(width: 50)
			}
			.padding(.horizontal, 5)
		}
		.frame(height: 50)
	}
}

struct SearchHistoryView: View {
	@Binding var searchHistories: [String]
	@Binding var query: String
	let onSearch: (String) -> Void
	let onDelete: (Int) -> Void
	
	var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			Text("최근 검색어")
				.font(.system(size: 14, weight: .bold))
				.foregroundStyle(.gray)
			
			if searchHistories.isEmpty {
				HStack {
					Spacer()
					Text("최근 검색어 내역이 없습니다.")
						.fontWeight(.bold)
						.padding(.top, 130)
					Spacer()
				}
			} else {
				ForEach(searchHistories.reversed().indices, id: \.self) { index in
					SearchHistoryRow(
						searchText: searchHistories[searchHistories.count - 1 - index],
						onSearch: { onSearch(searchHistories[searchHistories.count - 1 - index])
							query = searchHistories[searchHistories.count - 1 - index] },
						onDelete: { onDelete(searchHistories.count - 1 - index) }
					)
					Divider()
				}
				Button {
					searchHistories.removeAll()
				} label: {
					Text("검색어 전체삭제")
						.font(.system(size: 12))
						.foregroundStyle(.secondary)
				}
				
				
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	}
}

struct SearchHistoryRow: View {
	let searchText: String
	let onSearch: () -> Void
	let onDelete: () -> Void
	
	var body: some View {
		HStack(spacing: 16) {
			Button(action: onSearch) {
				HStack {
					Image(systemName: "clock.arrow.circlepath")
						.foregroundStyle(Color.secondary)
					Text(searchText)
						.font(.system(size: 16))
						.foregroundStyle(.primary)
					Spacer()
				}
			}
			Button(action: onDelete) {
				Image(systemName: "xmark")
					.foregroundStyle(Color.secondary)
			}
			.contentShape(Rectangle())
		}.padding(.vertical, 8)
	}
}

struct SearchResultsView: View {
	
	@Binding var combinedItems: [Item]
	@Binding var itemsByName: [Item]
	@Binding var itemsByImageText: [Item]
	
	@State var items: [Item] = []
	@State private var isSelected: Int = 0
	
	let onClear: () -> Void
	
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text("검색 결과")
					.fontWeight(.bold)
				Button(action: onClear) {
					Text("검색 결과 초기화")
						.foregroundStyle(.blue)
				}
			}
			
			Divider()
			HStack(spacing: 0) {
				Button {
					items = combinedItems
					isSelected = 0
				} label: {
					VStack {
						Text("통합검색")
							.foregroundStyle(isSelected == 0 ? .primary : .secondary)
						Divider()
							.frame(height: isSelected == 0 ? 1 : 0.5)
							.frame(maxWidth: .infinity)
							.background(isSelected == 0 ? .primary : .secondary)
					}
				}
				Button {
					items = itemsByName
					isSelected = 1
				} label: {
					VStack {
						Text("이름").foregroundStyle(isSelected == 1 ? .primary : .secondary)
						Divider()
							.frame(height: isSelected == 1 ? 1 : 0.5)
							.frame(maxWidth: .infinity)
							.background(isSelected == 1 ? .primary : .secondary)
					}
				}
				Button {
					items = itemsByImageText
					isSelected = 2
				} label: {
					VStack {
						Text("이미지텍스트").foregroundStyle(isSelected == 2 ? .primary : .secondary)
						Divider()
							.frame(height: isSelected == 2 ? 1 : 0.5)
							.frame(maxWidth: .infinity)
							.background(isSelected == 2 ? .primary : .secondary)
					}
					
				}
			}
			.fontWeight(.bold)
			.padding(.top)
			
			ForEach(items) { item in
				NavigationLink {
					ItemDetailView(item: item)
				} label: {
					ItemRowView(item: item, isSearch: true)
				}
			}
		}
	}
	
}

#Preview {
	let itemVM = ItemViewModel()
	SearchView().environmentObject(itemVM)
}
