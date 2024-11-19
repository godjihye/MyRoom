//
//  AddItemView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/19/24.
//

import SwiftUI

struct AddItemView: View {
    var body: some View {
			HStack {
				VStack(alignment: .leading) {
					VStack(alignment: .leading) {
						Text("• 사진 업로드")
							.bold()
						Button {
							
						} label: {
							ImgUploadRectBtn()
						}
					}
					VStack(alignment: .leading){
						Text("• 기본 정보")
							.bold()
						VStack(alignment: .leading) {
							Text("상품명")
								.bold()
							VStack(alignment: .leading, spacing: 0) {
								HStack {
									Text("AI 추천: ")
								}
								HStack {
									Text("직접 입력하기: ")
									AddItemTextField(width: 100)
								}
							}
							.padding(.horizontal)
							
							VStack(alignment: .leading, spacing: 0) {
								Text("위치")
									.bold()
								AddItemTextField(width: 100)
							}
							VStack(alignment: .leading, spacing: 0) {
								Text("상품 설명")
									.bold()
								AddItemTextField(width: 100)
							}
						}
						.padding(.horizontal)
					}
					VStack(alignment: .leading) {
						Text("• 부가 정보")
							.bold()
						VStack(alignment: .leading) {
							HStack {
								Text("가격")
								AddItemTextField(width: 100)
							}
							
							HStack {
								Text("구매 URL")
								AddItemTextField(width: 100)
							}
							HStack {
								Text("구매일자")
								AddItemTextField(width: 100)
							}
							HStack {
								Text("유통기한")
								AddItemTextField(width: 100)
							}
							HStack {
								Text("개봉일자")
								AddItemTextField(width: 100)
							}
						}
						.padding(.horizontal)
					}
				}
				Spacer()
				
			}
			.padding()
    }
}

#Preview {
    AddItemView()
}
