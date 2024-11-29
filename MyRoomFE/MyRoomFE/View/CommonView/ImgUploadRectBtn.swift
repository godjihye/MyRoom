//
//  ImgUploadRectBtn.swift
//  MyRoomFE
//
//  Created by jhshin on 11/19/24.
//

import SwiftUI

struct ImgUploadRectBtn: View {
    var body: some View {
			ZStack {
				RoundedRectangle(cornerRadius: 10)
					.frame(width: 100, height: 100)
					.foregroundStyle(.clear)
					.overlay(RoundedRectangle(cornerRadius: 10).stroke(.gray.opacity(0.5), lineWidth: 1))
				VStack(spacing:10) {
					Image(systemName: "plus.circle.fill")
					Text("사진 업로드")
				}
			}
    }
}

#Preview {
    ImgUploadRectBtn()
}
