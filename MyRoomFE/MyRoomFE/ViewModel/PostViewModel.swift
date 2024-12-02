//
//  PostViewModel.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//

import SwiftUI
import Alamofire

class PostViewModel:ObservableObject {
	@Published var posts:[Post]=[]  //무한스크롤
	@Published var postPhotos:[PostPhotos]=[]
	@Published var message = ""
	@Published var isAlertShowing = false
	let endPoint = Bundle.main.object(forInfoDictionaryKey: "ENDPOINT") as! String
	
	func fetchPosts() {
		let postUrl = "\(endPoint)/posts"
		
		AF.request(postUrl,method: .get).response { response in
			if let data = response.data {
				do {
					let root = try JSONDecoder().decode(PostRoot.self, from: data)
					self.posts.append(contentsOf: root.posts)
					
					if self.posts.isEmpty {
						self.isAlertShowing = true
						self.message = "등록된 상품이 없습니다."
					}
				} catch let error {
					self.isAlertShowing = true
					self.message = error.localizedDescription
				}
			}
		}
	}
	
	func fetchPostPhoto(postId:Int) {
		let postPhotoUrl = "\(endPoint)/postPhoto/\(postId)"
		
		AF.request(postPhotoUrl)
			.validate()
			.responseDecodable(of: [PostPhotos].self) { response in
				switch response.result {
				case .success(let photos):
					
					self.postPhotos = photos
				case .failure(let error):
					
					print("Error fetching photos: \(error.localizedDescription)")
				}
			}
	}
	
}
