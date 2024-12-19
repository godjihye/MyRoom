//
//  UsedListView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//

import SwiftUI

struct UsedListView: View {
	@EnvironmentObject var usedVM:UsedViewModel
	
	
	var body: some View {
		
		NavigationStack {
			ScrollView{
				
				LazyVStack{
					ForEach($usedVM.useds) { $used in
						NavigationLink() {
							UsedDetailView(used: $used, photos: used.images)
								.onAppear {
									Task{
										await usedVM.updateViewCnt(usedId: used.id)
									}
								}
						} label: {
							UsedRowView(used: used).padding(.horizontal)
						}
						.onAppear {
							if used == usedVM.useds.last {
								usedVM.fetchUseds()
							}
						}
					}.listStyle(.plain)
						.navigationTitle("중고거래")
					
				}
				
				.onAppear {
					usedVM.fetchUseds()
				}.toolbar {
					ToolbarItem(placement: .principal) {
						NavigationLink(destination: UsedSearchView()) {
							UsedSearchButton()
						}
					}
					ToolbarItem(placement: .topBarTrailing) {
						NavigationLink {
							UsedAddView().environmentObject(usedVM)
							
						} label: {
							Image(systemName: "plus.app")
						}
					}
					
				}
				
			}
			.refreshable {
				usedVM.page = 1
				usedVM.useds.removeAll()
				usedVM.fetchUseds() // 새로 고침 시 데이터를 불러오는 함수 호출
			}
			.alert("판매목록", isPresented: $usedVM.isFetchError) {
				Button("OK"){}
			} message: {
				Text(usedVM.message)
			}
			
		}
	}
}

struct UsedSearchButton: View {
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10)
				.frame(width: 280, height: 40)
				.foregroundStyle(Color(.systemGray6))
			HStack(spacing: 0) {
				Image(systemName: "magnifyingglass")
					.padding()
				Text("검색어를 입력하세요.")
					.font(.system(size: 15))
					.foregroundStyle(Color(.systemGray2))
				Spacer()
			}
		}
		.padding()
		//.frame(height: 35)
	}
}

//#Preview {
//    let used = UsedViewModel()
//    UsedListView().environmentObject(used)
//}
