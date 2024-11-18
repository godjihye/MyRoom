//
//  ItemListView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI

struct ItemListView: View {
	@EnvironmentObject var itemVM: ItemViewModel
	var location: Location
	var body: some View {
		NavigationView {
			if !itemVM.items.isEmpty{
				List(itemVM.items) { item in
					NavigationLink(destination: ItemDetailView(item: item)) {
						ItemRowView(item: item)
					}
				}
				.navigationTitle(location.locationName)
			} else {
				Text("아이템이 없네요...")
			}
				
		}
		
		
		.listStyle(InsetGroupedListStyle())
		
		.task {
			await itemVM.fetchItems(locationId: location.id) // 데이터 가져오기
		}
	}
}

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

struct ItemDetailView: View {
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
			Text("Color: \(item.color)")
				.font(.body)
				.foregroundColor(.gray)
			
			Text("Price: \(item.price)원")
				.font(.headline)
			if let url = item.url {
				Link("View Online", destination: URL(string: url)!)
					.foregroundColor(.blue)
					.padding(.top)
				
				Spacer()
			}
		}
		.padding()
		.navigationTitle("Item Detail")
	}
}

