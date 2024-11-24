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
	@Published var message: String = ""
	@Published var isShowingAlert: Bool = false
	func fetchItems(locationId: Int) async {
		let url = "\(endPoint)/items/\(locationId)"
		do {
			let response = try await AF.request(url, method: .get)
				.serializingDecodable(ItemResponse.self).value
			DispatchQueue.main.async {
				self.items = response.documents
				print(self.items.first)
			}
			print("fetchItems complete!")
		} catch {
			if let afError = error as? AFError {
				print("Alamofire Error: \(afError)")
			} else {
				print("Unexpected Error: \(error)")
			}
		}
	}
	func fetchFavItems(locationId: Int) async {
		let url = "\(endPoint)/items/favList/\(locationId)"
		do {
			let response = try await AF.request(url,method: .get).serializingDecodable(ItemResponse.self).value
			DispatchQueue.main.async { self.favItems = response.documents }
			print("fetchFavItems Complete")
		} catch {
			print("fetchFavItems Error: \(error)")
		}
	}
	func addItem(itemName: String?, purchaseDate: String?, expiryDate: String?, itemUrl: String?, image: UIImage?, desc: String?, color: String?, isFav: Bool? = false, price: Int?, openDate: String?, locationId: Int?) async {
		let url = "\(endPoint)/items"
		let params: Parameters = [
			"itemName": itemName,
			"purchaseDate": purchaseDate,
			"expiryDate": expiryDate,
			"url": itemUrl,
			"photo": "https://data.onnada.com/character/202406/thumb_1982740661_05661aad_2050_1.png",
			"desc": desc,
			"color": "rose gold",
			"isFav": true,
			"price": 2000,
			"locationId": locationId
		]
		do {
			let response = try await AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).serializingData().value
			print(response.description)
		} catch {
			print("do-try-catch error!")
		}
	}
	func updateItem(itemId: Int, itemName: String?, purchaseDate: String?, expiryDate: String?, itemUrl: String?, image: String?, desc: String?, color: String?, price: Int?, openDate: String?, locationId: Int?) async {
		let url = "\(endPoint)/items/\(itemId)"
		let params: Parameters = [
			"itemName": itemName,
			"purchaseDate": purchaseDate,
			"expiryDate": expiryDate,
			"url": itemUrl,
			"photo": "https://i.namu.wiki/i/T6CkUjJqyNWEudh3KBic3zcUeUo0Ugpl-V6XvfjZb6Cz3pdJ0ACGRSYlIkO9u6iYQELSPgQnWAZqnw5V1kQyOsFYRPNe203Q3BtyPh4bvWLxJ-CVt0k56aCmwqc_gw5VXFq7U2jPXdm5J1Vs2KY7BA.webp",
			"desc": desc,
			"color": "rose gold",
			"isFav": true,
			"price": price,
			"locationId": locationId
		]
		do {
			let response = try await AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default).serializingData().value
			print(response)
		} catch {
			print("do-try-catch error!")
		}
	}
	func removeItem(itemId: Int) async {
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
	func updateItemFav(itemId: Int, itemFav: Bool) async {
		let url = "\(endPoint)/items/\(itemId)"
		let params: Parameters = [
			"isFav": !itemFav
		]
		do {
			let response = try await AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default).serializingData().value
			print(response)
		} catch {
			print("do-try-catch error!")
		}
	}
}

private func addFormData(formData: MultipartFormData, optionalString: String?, withName: String) {
	guard let str = optionalString else { return }
	formData.append(str.data(using: .utf8)!, withName: withName)
}
