//
//  ItemViewModel.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI
import Alamofire

class ItemViewModel: ObservableObject {
	@Published var items: [Item] = []
	@Published var favItems: [Item] = []
	@Published var message: String = ""
	@Published var isShowingAlert: Bool = false
	@Published var searchResultItems: [Item] = []
	@Published var isAddShowing: Bool = false
	let endPoint = Bundle.main.object(forInfoDictionaryKey: "ENDPOINT") as! String
	let userId = UserDefaults.standard.value(forKey: "userId") as! Int
	
	//MARK: CRUD
	// 1. Create Item
	func addItem(itemName: String?, purchaseDate: String?, expiryDate: String?, itemUrl: String?, image: UIImage?, desc: String?, color: String?, isFav: Bool? = false, price: Int?, openDate: String?, locationId: Int?) async throws -> ItemResponse {
		let url = "\(endPoint)/items"
		let userId = UserDefaults.standard.integer(forKey: "userId")
		let headers: HTTPHeaders = ["Content-Type": "multipart/form-data"]
		
		guard let image, let imageData = image.jpegData(compressionQuality: 0.2) else {
			throw NSError(domain: "addItem", code: 1, userInfo: [NSLocalizedDescriptionKey: "Image cannot be nil"])
		}
		guard let itemName = itemName,
					let locationId = locationId,
					let isFav = isFav else {
			throw NSError(domain: "addItem", code: 2, userInfo: [NSLocalizedDescriptionKey: "Required parameters are missing"])
		}
		
		var formData = MultipartFormData()
		formData.append(imageData, withName: "photo", fileName: "itemPhoto.jpg", mimeType: "image/jpeg")
		addFormData(formData: formData, optionalString: itemName, withName: "itemName")
		addFormData(formData: formData, optionalString: purchaseDate, withName: "purchaseDate")
		addFormData(formData: formData, optionalString: expiryDate, withName: "expiryDate")
		addFormData(formData: formData, optionalString: itemUrl, withName: "itemUrl")
		addFormData(formData: formData, optionalString: desc, withName: "desc")
		addFormData(formData: formData, optionalString: color, withName: "color")
		addFormData(formData: formData, optionalString: openDate, withName: "openDate")
		formData.append(isFav.description.data(using: .utf8)!, withName: "isFav")
		if let price = price {
			formData.append(price.description.data(using: .utf8)!, withName: "price")
		}
		formData.append(locationId.description.data(using: .utf8)!, withName: "locationId")
		
		let dataTask = AF.upload(multipartFormData: formData, to: url, headers: headers)
			.serializingDecodable(ItemResponse.self)
		
		do {
			let response = try await dataTask.value
			return response
		} catch {
			throw error
		}
	}
	
	
	// 2. Read Items
	/// 2-1. Read All Items (location)
	func fetchItems(locationId: Int) async {
		let url = "\(endPoint)/items/\(locationId)"
		do {
			let response = try await AF.request(url, method: .get)
				.serializingDecodable(ItemResponse.self).value
			DispatchQueue.main.async {
				self.items = response.documents
			}
			log("fetchItems Complete", trait: .success)
		} catch {
			if let afError = error as? AFError {
				log("AFError: \(afError.localizedDescription)", trait: .error)
			} else {
				log("UnexpectedError: \(error.localizedDescription)", trait: .error)
			}
		}
	}
	/// 2-2. Read Fav Items (All location)
	func fetchFavItems() async {
		let url = "\(endPoint)/items/fav/\(userId)"
		do {
			let response = try await AF.request(url,method: .get).serializingDecodable(ItemResponse.self).value
			DispatchQueue.main.async { self.favItems = response.documents }
			log("fetchFavItems Complete", trait: .success)
		} catch {
			log("fetchFavItems Error: \(error.localizedDescription)", trait: .error)
		}
	}
	
	// 3. Update Item
	func editItem(itemId: Int, itemName: String?, purchaseDate: String?, expiryDate: String?, itemUrl: String?, image: UIImage?, desc: String?, color: String?, isFav: Bool? = false, price: Int?, openDate: String?, locationId: Int?) async {
		let url = "\(endPoint)/items/\(itemId)"
		//let userId = UserDefaults.standard.integer(forKey: "userId")
		//guard let token = UserDefaults.standard.string(forKey: "token") else { log("token can't unwrapping", trait: .error); return}
		let headers: HTTPHeaders = ["Content-Type": "multipart/form-data"]
		guard let image, let imageData = image.jpegData(compressionQuality: 0.2) else {return}
		guard let itemName = itemName,
					let locationId = locationId,
					let isFav = isFav else { return }
		let formData = MultipartFormData()
		formData.append(imageData, withName: "photo", fileName: "itemPhoto.jpg", mimeType: "image/jpeg")
		addFormData(formData: formData, optionalString: itemName, withName: "itemName")
		addFormData(formData: formData, optionalString: purchaseDate, withName: "purchaseDate")
		addFormData(formData: formData, optionalString: expiryDate, withName: "expiryDate")
		addFormData(formData: formData, optionalString: itemUrl, withName: "itemUrl")
		addFormData(formData: formData, optionalString: desc, withName: "desc")
		addFormData(formData: formData, optionalString: color, withName: "color")
		addFormData(formData: formData, optionalString: openDate, withName: "openDate")
		formData.append(isFav.description.data(using: .utf8)!, withName: "isFav")
		if let price = price {
			formData.append(price.description.data(using: .utf8)!, withName: "price")
		}
		formData.append(locationId.description.data(using: .utf8)!, withName: "locationId")
		
		AF.upload(multipartFormData: formData, to: url, method: .put, headers: headers).response { response in
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200..<300:
					if let data = response.data {
						do {
							let root = try JSONDecoder().decode(ItemResponse.self, from: data)
							log("updateItem Complete", trait: .success)
							//self.isAddShowing = true
							//self.message = root.message
						} catch{
							if let afError = error as? AFError {
								log("updateItem AFError: \(afError.localizedDescription)", trait: .error)
							} else {
								log("updateItem UnexpectedError: \(error.localizedDescription)", trait: .error)
							}
							//self.isAddShowing = true
							//self.message = error.localizedDescription
						}
					}
				case 300..<600:
					if let data = response.data {
						do {
							self.isAddShowing = true
							let apiError = try JSONDecoder().decode(APIError.self, from: data)
							self.message = apiError.message
						} catch let error {
							self.isAddShowing = true
							self.message = error.localizedDescription
						}
					}
				default:
					self.isAddShowing = true
					self.message = "네트워크 오류입니다."
				}
			}
		}
	}
	
	// 4. Delete Item
	func removeItem(itemId: Int) async {
		let url = "\(endPoint)/items/\(itemId)"
		do {
			let response = try await AF.request(url, method: .delete).serializingData().value
			log("removeItem Complete! \(response.description)", trait: .success)
		} catch {
			log("removeItem Error: \(error.localizedDescription)", trait: .error)
		}
	}
	
	// Fav 등록 / 해제
	func updateItemFav(itemId: Int, itemFav: Bool) async {
		let url = "\(endPoint)/items/\(itemId)"
		let params: Parameters = [
			"isFav": !itemFav
		]
		do {
			let response = try await AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default).serializingData().value
			log("updateItemFav complete! \(response.description)", trait: .success)
		} catch {
			log("updateItemFav Error", trait: .error)
			log("do-try-catch error!", trait: .error)
		}
	}
	
	// 추가 사진 등록, 수정
	func addAdditionalPhotos(images: [UIImage]?, itemId: Int?) async {
		guard let images, let itemId else {return}
		if images.isEmpty {return}
		log("images.is not Empty")
		let url = "\(endPoint)/additionalPhoto/\(itemId)"
		let headers: HTTPHeaders = ["Content-Type": "multipart/form-data"]
		let formData = MultipartFormData()
		for (index, image) in images.enumerated() {
			if let imageData = image.jpegData(compressionQuality: 0.8) {
				formData.append(
					imageData,
					withName: "photos", // 서버에서 기대하는 키
					fileName: "photo\(index + 1).jpg",
					mimeType: "image/jpeg"
				)
			}
		}
		AF.upload(multipartFormData: formData, to: url, method: .put, headers: headers).response { response in
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200..<300:
					if let data = response.data {
						do {
							let root = try JSONDecoder().decode(ItemResponse.self, from: data)
							log("addAdditionalPhotos", trait: .success)
						} catch{
							if let afError = error as? AFError {
								log("AFError: \(afError.localizedDescription)", trait: .error)
							} else {
								log("UnexpectedError: \(error.localizedDescription)", trait: .error)
							}
						}
					}
				case 300..<600:
					if let data = response.data {
						do {
							self.isAddShowing = true
							let apiError = try JSONDecoder().decode(APIError.self, from: data)
							self.message = apiError.message
						} catch let error {
							self.isAddShowing = true
							self.message = error.localizedDescription
						}
					}
				default:
					self.isAddShowing = true
					self.message = "네트워크 오류입니다."
				}
			}
		}
	}
	
	// Search Item
	func searchItem(query: String?) async {
		guard let query = query else { return }
		let url = "\(endPoint)/items/search"
		let params: Parameters = ["userId": userId,"query": query]
		do {
			let response = try await AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).serializingDecodable(ItemResponse.self).value
			DispatchQueue.main.async { self.searchResultItems = response.documents }
		} catch {
			if let afError = error as? AFError {
				log("AFError: \(afError.localizedDescription)", trait: .error)
			} else {
				log("UnexpectedError: \(error.localizedDescription)", trait: .error)
			}
		}
	}
	
	// Clear Search Result
	func clearSearchResult() {
		searchResultItems.removeAll()
	}
}

private func addFormData(formData: MultipartFormData, optionalString: String?, withName: String) {
	guard let str = optionalString else { return }
	formData.append(str.data(using: .utf8)!, withName: withName)
}
