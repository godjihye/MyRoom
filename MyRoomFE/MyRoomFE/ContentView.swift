//
//  ContentView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
			EntryView().environmentObject(UserViewModel()).environmentObject(RoomViewModel())
    }
}

#Preview {
    ContentView()
}
