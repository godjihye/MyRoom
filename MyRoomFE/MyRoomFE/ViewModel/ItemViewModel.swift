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
	
	//MARK: - CRUD
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
		addFormData(formData: formData, optionalString: isFav.description, withName: "isFav")
		addFormData(formData: formData, optionalString: price?.description, withName: "price")
//		if let price = price {
//			formData.append(price.description.data(using: .utf8)!, withName: "price")
//		}
		addFormData(formData: formData, optionalString: locationId.description, withName: "locationId")
		//formData.append(locationId.description.data(using: .utf8)!, withName: "locationId")
		
		let dataTask = AF.upload(multipartFormData: formData, to: url, headers: headers).serializingDecodable(ItemResponse.self)
		
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
	
	//FIXME: -Update Item Optional Field
	// 3. Update Item (** patch)
	func editItem(itemId: Int, itemName: String?, purchaseDate: String?, expiryDate: String?, itemUrl: String?, image: UIImage?, desc: String?, color: String?, price: Int?, openDate: String?, locationId: Int?) async {
		
		log("itemId: \(itemId), itemName: \(itemName), purchaseDate: \(purchaseDate), expiryDate: \(expiryDate), itemUrl: \(itemUrl), image: \(image), desc: \(desc), color: \(color), price\(price), openDate: \(openDate), locationId:\(locationId)")
		let url = "\(endPoint)/items/\(itemId)"
		let headers: HTTPHeaders = ["Content-Type": "multipart/form-data"]
		
		let formData = MultipartFormData()
		if let itemName {
			formData.append(itemName.data(using: .utf8)!, withName: "itemName")
			log("formData appended! itemName")
		}
		if let purchaseDate {
			formData.append(purchaseDate.description.data(using: .utf8)!, withName: "purchaseDate")
			log("formData appended! purchaseDate")
		}
		if let expiryDate {
			formData.append(expiryDate.description.data(using: .utf8)!, withName: "expiryDate")
			log("formData appended! expiryDate")
		}
		if let openDate {
			formData.append(openDate.description.data(using: .utf8)!, withName: "openDate")
			log("formData appended! openDate")
		}
		if let itemUrl {
			formData.append(itemUrl.data(using: .utf8)!, withName: "url")
			log("formData appended! itemUrl")
		}
		if let image {
			if let imageData = image.jpegData(compressionQuality: 0.8) {
				formData.append(imageData, withName: "photo", fileName: "itemPhoto.jpg", mimeType: "image/jpeg")
				log("formData appended! image")
			}
		}
		if let desc {
			formData.append(desc.data(using: .utf8)!, withName: "desc")
			log("formData appended! desc")
		}
		if let color {
			formData.append(color.data(using: .utf8)!, withName: "color")
			log("formData appended! color")
		}
		if let price {
			formData.append(price.description.data(using: .utf8)!, withName: "price")
			log("formData appended! price")
		}
		if let locationId {
			formData.append(locationId.description.data(using: .utf8)!, withName: "locationId")
			log("formData appended! locationId")
		}
		do {
			let response = try await AF.upload(multipartFormData: formData, to: url, method: .patch, headers: headers).serializingDecodable(ApiResponse.self).value
			self.message = response.message
		} catch {
//			self.message = "물건 정보를 수정하는데 실패했습니다."
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
			let response = try await AF.request(url, method: .patch, parameters: params, encoding: JSONEncoding.default).serializingData().value
			log("updateItemFav complete! \(response.description)", trait: .success)
		} catch {
			log("updateItemFav Error", trait: .error)
			log("do-try-catch error!", trait: .error)
		}
	}
	
	// 추가 사진 등록
	func addAdditionalPhotos(images: [UIImage]?, itemId: Int?) async {
		guard let images, let itemId else {return}
		if images.isEmpty {return}
		let url = "\(endPoint)/items/additionalPhoto/\(itemId)"
		let headers: HTTPHeaders = ["Content-Type": "multipart/form-data"]
		let formData = MultipartFormData()
		for (index, image) in images.enumerated() {
			if let imageData = image.jpegData(compressionQuality: 0.8) {
				formData.append(imageData, withName: "photos", fileName: "photo\(index + 1).jpg", mimeType: "image/jpeg")
			}
		}
		AF.upload(multipartFormData: formData, to: url, method: .post, headers: headers).response { response in
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
							let apiError = try JSONDecoder().decode(ApiResponse.self, from: data)
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
	
	// 추가 사진 삭제
	func removeAdditionalPhoto(photoId: Int) {
		let url = "\(endPoint)/items/additionalPhoto/\(photoId)"
		AF.request(url, method: .delete).response { response in
			guard let statusCode = response.response?.statusCode else { return }
			switch statusCode {
			case 200..<300:
				log("removeAdditionalPhotoSuccessfully")
			default:
				log("removeAdditionalPhoto Fail", trait: .error)
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

//MARK: - Helper Method

private func addFormData(formData: MultipartFormData, optionalString: String?, withName: String) {
	guard let str = optionalString else { return }
	formData.append(str.data(using: .utf8)!, withName: withName)
}
