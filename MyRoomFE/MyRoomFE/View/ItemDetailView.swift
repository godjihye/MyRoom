//
//  ItemDetailView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/19/24.
//

import SwiftUI

struct ItemDetailView: View {
	@Binding var showHeaderView: Bool
	let item: Item
	var body: some View {
		VStack(spacing: 20) {
			if let photo = item.photo {
				AsyncImage(url: URL(string: photo)) { image in
					image
						.resizable()
						.scaledToFit()
						.frame(maxHeight: 300)
				} placeholder: {
					ProgressView()
				}
			}
			Text(item.itemName)
				.font(.title)
				.padding()
			if let desc = item.desc{
				Text(desc)
					.font(.body)
					.padding()
			}
			Text("Color: \(item.color ?? "")")
				.font(.body)
				.foregroundColor(.gray)
			
			Text("Price: \(item.price ?? 0)원")
				.font(.headline)
			if let url = item.url {
				Link("View Online", destination: URL(string: url)!)
					.foregroundColor(.blue)
					.padding(.top)
				
				Spacer()
			}
		}
		.onAppear {
			showHeaderView = false
		}
		.padding()
		.navigationTitle("Item Detail")
	}
}


//
//#Preview {
//	ItemDetailView(item: sample)
//}
