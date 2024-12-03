//
//  Entry.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI

struct EntryView: View {
    var body: some View {
			TabView {
				HomeView()
					.environmentObject(RoomViewModel()).environmentObject(ItemViewModel())
					.tabItem {
						Image(systemName: "house")
						Text("홈")
					}
                UsedAddView().environmentObject(UsedViewModel())
                    .tabItem {
                        Image(systemName: "plus")
                        Text("test중..")
                    }
			}
    }
}

#Preview {
	let roomVM = RoomViewModel()
	let itemVM = ItemViewModel()
	EntryView().environmentObject(roomVM).environmentObject(itemVM)
}
