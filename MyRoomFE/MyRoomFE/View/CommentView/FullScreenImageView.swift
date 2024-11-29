//
//  FullScreenImageView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/24/24.
//

import SwiftUI
let testURLs = [
			 URL(string: "https://sayangpaysj.blob.core.windows.net/yangpa/test1"),
			 URL(string: "https://sayangpaysj.blob.core.windows.net/yangpa/test2"),
			 URL(string: "https://sayangpaysj.blob.core.windows.net/yangpa/test3")
	 ].compactMap({ $0 })  // compactMap을 사용하여 nil 제거
	 
struct FullScreenImageView: View {
		let imageURLs: [URL]
				@State private var selectedIndex: Int

				init(imageURLs: [URL], selectedIndex: Int) {
						self.imageURLs = imageURLs
						self._selectedIndex = State(initialValue: selectedIndex)
				}
		@Environment(\.presentationMode) var presentationMode
		var body: some View {
				ZStack {
						Color.black.edgesIgnoringSafeArea(.all) // 배경 검정색
						VStack {
								TabView(selection: $selectedIndex) {
														ForEach(0..<imageURLs.count, id: \.self) { index in
																AsyncImage(url: imageURLs[index]) { image in
																		image.resizable()
																				.scaledToFit()
																				.tag(index)
																} placeholder: {
																		ProgressView()
																}
														}
												}
												.tabViewStyle(.page) // Add horizontal scrolling
												.background(Color.black.edgesIgnoringSafeArea(.all))
							 
							 Spacer()
							 Button("닫기") {
									 presentationMode.wrappedValue.dismiss()
							 }
							 .foregroundColor(.white)
							 .padding()
					 }
			 }
		}
}

#Preview {
	 
		FullScreenImageView(imageURLs: testURLs, selectedIndex: 0)
		
}
