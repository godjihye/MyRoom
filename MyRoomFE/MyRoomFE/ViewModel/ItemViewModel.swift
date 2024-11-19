//
//  ItemViewModel.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import Foundation
import Alamofire

class ItemViewModel: ObservableObject {
	let endPoint = Bundle.main.object(forInfoDictionaryKey: "ENDPOINT") as! String
	@Published var items: [Item] = []
	@Published var favItems: [Item] = []
	func fetchItems(locationId: Int) async {
		let url = "\(endPoint)/items/\(locationId)"
		print(url)
		AF.request(url,method: .get)
			.response { response in
				if let statusCode = response.response?.statusCode {
					switch statusCode {
					case 200..<300:
						if let data = response.data {
							do {
								let root = try JSONDecoder().decode(ItemResponse.self, from: data)
								self.items = root.documents
							}catch let error {
								print("error: \(error)")
							}
						}
					default:
						print("네트워크 오류")
					}
				}
			}
	}
	func fetchFavItems(locationId: Int) async {
		let url = "\(endPoint)/items/favList/\(locationId)"
		print(url)
		AF.request(url,method: .get)
			.response { response in
				if let statusCode = response.response?.statusCode {
					switch statusCode {
					case 200..<300:
						if let data = response.data {
							do {
								let root = try JSONDecoder().decode(ItemResponse.self, from: data)
								self.favItems = root.documents
								print(self.favItems)
							} catch let error {
								print("error: \(error)")
							}
						}
					default:
						print("네트워크 오류")
					}
				}
			}
	}
}
