//
//  FavItemRow.swift
//  MyRoomFE
//
//  Created by jhshin on 11/19/24.
//

import SwiftUI
import Foundation

//let sample = Item(id: 14, itemName: "다이소 물티슈", purchaseDate: Optional("2024-11-19T00:00:00.000Z"), expiryDate: Optional("2025-11-18T00:00:00.000Z"), url: Optional("https://www.daisomall.co.kr/pd/pdr/SCR_PDR_0001?pdNo=1017947&recmYn=N"), photo: Optional("https://cdn.daisomall.co.kr/file/PD/20240628/S2GacZCWu6MAZHG6b9cB1017947_00_00S2GacZCWu6MAZHG6b9cB.jpg/dims/resize/600/quality/95"), desc: Optional("다이소 뷰러 핑크색"), color: Optional("rose gold"), isFav: true, price: Optional(2000), openDate: nil, locationId: 1, createdAt: Optional("2024-11-19T01:23:56.426Z"), updatedAt: Optional("2024-11-19T01:23:56.426Z"))
struct FavItemRow: View {
	let item: Item
	var dateFormatter = DateFormatter()
	
	var body: some View {
		VStack {
			AsyncImage(url: URL(string: item.photo!)) { image in
				image.image?.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: 160, height: 160)
					.clipShape(RoundedRectangle(cornerRadius: 10))
			}
			Text(item.itemName)
				.bold()
			Text(item.purchaseDate?.split(separator: "T")[0] ?? "")
				.foregroundStyle(.secondary)
		}
		.frame(maxWidth: .infinity)
		.aspectRatio(1, contentMode: .fit)
	}
}

//#Preview {
//	FavItemRow(item: sample)
//}
