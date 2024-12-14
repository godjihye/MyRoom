//
//  UsedListView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//

import SwiftUI

struct UsedListView: View {
		@EnvironmentObject var usedVM: UsedViewModel
		
		var body: some View {
				NavigationSplitView {
						contentView
								.navigationTitle("중고거래")
								.toolbar { toolbarContent }
				} detail: {
						Text("판매 목록")
				}
				.refreshable { refreshData() }
				.alert("판매목록", isPresented: $usedVM.isFetchError) {
						Button("OK") {}
				} message: {
						Text(usedVM.message)
				}
		}
}

// MARK: - Subviews & Components
extension UsedListView {
		private var contentView: some View {
				ScrollView {
						LazyVStack {
								ForEach($usedVM.useds) { $used in
										NavigationLink {
												UsedDetailView(used: $used, photos: used.images)
														.environmentObject(ChatViewModel())
														.onAppear { updateViewCount(for: used.id) }
										} label: {
												UsedRowView(used: used)
														.padding(.horizontal)
										}
										.onAppear { loadMoreDataIfNeeded(for: used) }
								}
						}
				}
				.onAppear { usedVM.fetchUseds() }
		}
		
		private var toolbarContent: some ToolbarContent {
				ToolbarItemGroup(placement: .topBarTrailing) {
						NavigationLink {
								UsedAddView().environmentObject(usedVM)
						} label: {
								Image(systemName: "plus.app")
						}
						
						Button(action: {}) {
								Image(systemName: "return")
						}
				}
		}
}

// MARK: - Helper Functions
extension UsedListView {
		private func refreshData() {
				usedVM.page = 1
				usedVM.useds.removeAll()
				usedVM.fetchUseds()
		}
		
		private func loadMoreDataIfNeeded(for used: Used) {
				guard used == usedVM.useds.last else { return }
				usedVM.fetchUseds()
		}
		
		private func updateViewCount(for usedId: Int) {
				Task {
						await usedVM.updateViewCnt(usedId: usedId)
				}
		}
}

//#Preview {
//    let used = UsedViewModel()
//    UsedListView().environmentObject(used)
//}
