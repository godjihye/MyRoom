//
//  ContentView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/14/24.
//

import SwiftUI

struct ContentView: View {
	@State var isLaunching: Bool = true
	var body: some View {
		if isLaunching {
			SplashView()
				.onAppear {
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						isLaunching = false
					}
				}
		} else {
			EntryView().environmentObject(UserViewModel()).environmentObject(RoomViewModel())
		}
	}
}
struct SplashView: View {
	
	var body: some View {
		Image("logo")
			.resizable()
			.frame(width: 100, height: 80)
	}
}
#Preview {
	ContentView()
}
