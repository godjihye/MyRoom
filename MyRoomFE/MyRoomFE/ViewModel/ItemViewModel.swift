//
//  ItemViewModel.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI
import Alamofire

class ItemViewModel: ObservableObject {
	let endPoint = Bundle.main.object(forInfoDictionaryKey: "ENDPOINT") as! String
	@Published var items: [Item] = []
	@Published var favItems: [Item] = []
	func fetchItems(locationId: Int) {
		let url = "\(endPoint)/items/\(locationId)"
		AF.request(url,method: .get)
			.response { response in
				if let statusCode = response.response?.statusCode {
					switch statusCode {
					case 200..<300:
						if let data = response.data {
							do {
								let root = try JSONDecoder().decode(ItemResponse.self, from: data)
								self.items = root.documents
								print(self.items.first)
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
	func fetchFavItems(locationId: Int) {
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
	func addItem(itemName: String?, purchaseDate: String?, expiryDate: String?, itemUrl: String?, image: UIImage?, desc: String?, color: String?, isFav: Bool? = false, price: Int?, openDate: String?, locationId: Int?) {
		let url = "\(endPoint)/items"
		let params: Parameters = [
			"itemName": itemName,
			"purchaseDate": purchaseDate,
			"expiryDate": expiryDate,
			"url": itemUrl,
			"photo": "https://i.namu.wiki/i/T6CkUjJqyNWEudh3KBic3zcUeUo0Ugpl-V6XvfjZb6Cz3pdJ0ACGRSYlIkO9u6iYQELSPgQnWAZqnw5V1kQyOsFYRPNe203Q3BtyPh4bvWLxJ-CVt0k56aCmwqc_gw5VXFq7U2jPXdm5J1Vs2KY7BA.webp",
			"desc": desc,
			"color": "rose gold",
			"isFav": true,
			"price": 2000,
			"locationId": locationId
		]
		AF.request(url,method: .post,parameters: params,encoding: JSONEncoding.default)
			.response { response in
				switch response.result {
				case .success(_):
					print("success!")
				case .failure(let error):
					print("Error: \(error)")
				}
			}
	}
	func deleteItem(itemId: Int) {
		let url = "\(endPoint)/items/\(itemId)"
		AF.request(url, method: .delete)
			.response { response in
				if let statusCode = response.response?.statusCode {
					switch statusCode {
					case 200..<300:
						print("success")
					default:
						print("Network error")
					}
				}
			}
	}
}

func addFormData(formData: MultipartFormData, optionalString: String?, withName: String) {
	guard let str = optionalString else { return }
	formData.append(str.data(using: .utf8)!, withName: withName)
}
