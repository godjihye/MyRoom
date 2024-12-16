//
//  UsedItemTestView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/23/24.
//

import SwiftUI

let isMyItemPresented: Bool = false
struct UsedItemRowView: View {
	@EnvironmentObject var itemVM: ItemViewModel
	
	@Binding var selectedItem: Item?
	@Binding var isMyItemPresented:Bool
	
	let azuerTarget = Bundle.main.object(forInfoDictionaryKey: "AZURESTORAGE") as! String
	
	let item: Item
	var body: some View {
		VStack {
			if let photo = item.photo {
				AsyncImage(url: URL(string: "\(azuerTarget)\(photo)")) { image in
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
				
			}
			Spacer()
		}
		.onTapGesture {
			selectedItem = item
			isMyItemPresented.toggle()
		}
		.onAppear(perform: {
			print("item chk : \(item)")
		})
		.padding(.vertical, 8)
		
	}
	
}


//#Preview {
//        let itemVM = ItemViewModel()
//    UsedItemRowView(selectedItem: .constant(sampleItem), isMyItemPresented: .constant(isMyItemPresented), item: sampleItem).environmentObject(itemVM)
//}
