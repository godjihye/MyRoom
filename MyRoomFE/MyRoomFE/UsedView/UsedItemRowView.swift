//
//  UsedItemTestView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/23/24.
//

import SwiftUI
let items = ["20241112", "3000", "왼쪽아래 쪼끔 까졌음 살때 중고로샀었음 지문자국좀 많음", "20241112","url입니다~"]

struct UsedItemRowView: View {
    @EnvironmentObject var itemVM: ItemViewModel
    let item: Item
    @State private var itemFav: Bool = false
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
            }
            .padding(.vertical, 8)
        }

    }


#Preview {
    let itemVM = ItemViewModel()
    UsedItemRowView(item: sampleItem).environmentObject(itemVM)
}
