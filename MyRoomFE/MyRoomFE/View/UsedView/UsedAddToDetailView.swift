//
//  UsedAddToDetailView.swift
//  MyRoomFE
//
//  Created by 이수정 on 12/6/24.
//

import SwiftUI

struct UsedAddToDetailView: View {
    @State private var isComplete = false
    @State private var usedItem: Used
    
    var body: some View {
        NavigationView {
                   VStack {
                       if isComplete {
                           // 등록 완료되면 디테일 뷰로 전환
//                           if let usedItem {
////                               UsedDetailView(used: usedItem, use)
//                           }
                       } else {
                           // 등록이 완료되지 않으면 등록 화면 (usedAddView) 표시
//                           UsedAddView(isComplete: $isComplete, usedItem: $usedItem)
                       }
                   }
               }
    }
}

#Preview {
//    UsedAddToDetailView()
}
