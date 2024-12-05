//
//  ProfileRow.swift
//  MyRoomFE
//
//  Created by jhshin on 12/5/24.
//

import SwiftUI

struct ProfileRow: View {
	var user: User
    var body: some View {
			HStack {
				if let userImage = user.userImage {
					AsyncImage(url: URL(string: userImage)) { image in
						image.resizable()
							.frame(width: 80, height: 80)
							.clipShape(Circle())
					} placeholder: {
						ProgressView()
//						Image(systemName: "person")
					}
					Text(user.userName)
						.bold()
					
				}
				Spacer()
			}
    }
}

#Preview {
	ProfileRow(user: sampleUser)
}
