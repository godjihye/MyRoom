//
//  ItemRowView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/19/24.
//

import SwiftUI

struct ItemRowView: View {
	let item: Item
	var body: some View {
		HStack {
			if let photo = item.photo {
				AsyncImage(url: URL(string: photo)) { image in
					image
						.resizable()
						.scaledToFill()
						.frame(width: 50, height: 50)
						.clipShape(RoundedRectangle(cornerRadius: 8))
				} placeholder: {
					ProgressView()
				}
			}
			VStack(alignment: .leading, spacing: 5) {
				Text(item.itemName)
					.font(.headline)
				if let desc = item.desc {
					Text(desc)
						.font(.subheadline)
						.foregroundColor(.secondary)
				}
			}
			Spacer()
			
			// 즐겨찾기 여부 표시
			if item.isFav {
				Image(systemName: "star.fill")
					.foregroundColor(.yellow)
			}
		}
		.padding(.vertical, 8)
	}
}
//
//#Preview {
//	ItemRowView(item: sample)
//}
