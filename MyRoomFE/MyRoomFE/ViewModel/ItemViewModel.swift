//
//  ItemViewModel.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import SwiftUI
import Alamofire
import SVProgressHUD


class ItemViewModel: ObservableObject {
	
	@Published var items: [Item] = []
	@Published var favItems: [Item] = []
	@Published var currentItem: Item?
	@Published var message: String = ""
	@Published var isShowingAlert: Bool = false
	@Published var searchResultItems: [Item] = []
	@Published var isAddShowing: Bool = false
	
	// ALERT STATE VARIABLES
	@Published var isShowingAlertAddAdditionalPhotos: Bool = false
	@Published var addAdditionalPhotosMessage: String = ""
	
	let endPoint = Bundle.main.object(forInfoDictionaryKey: "ENDPOINT") as! String
	let userId = UserDefaults.standard.integer(forKey: "userId")
	let homeId = UserDefaults.standard.integer(forKey: "homeId")
	
	//MARK: - CRUD
	//MARK: - 1. Create Item
	func addItem(itemName: String?, purchaseDate: String?, expiryDate: String?, itemUrl: String?, image: UIImage?, desc: String?, color: String?, isFav: Bool? = false, price: Int?, openDate: String?, locationId: Int?) {
		let url = "\(endPoint)/items"
		
		let headers: HTTPHeaders = ["Content-Type": "multipart/form-data"]
		
		guard let image, let imageData = image.jpegData(compressionQuality: 0.2) else {
			return
		}
		guard let itemName = itemName,
					let locationId = locationId,
					let isFav = isFav else {
			return
		}
		
		let formData = MultipartFormData()
		formData.append(imageData, withName: "photo", fileName: "itemPhoto.jpg", mimeType: "image/jpeg")
		addFormData(formData: formData, optionalValue: itemName, withName: "itemName")
		addFormData(formData: formData, optionalValue: purchaseDate, withName: "purchaseDate")
		addFormData(formData: formData, optionalValue: expiryDate, withName: "expiryDate")
		addFormData(formData: formData, optionalValue: itemUrl, withName: "url")
		addFormData(formData: formData, optionalValue: desc, withName: "desc")
		addFormData(formData: formData, optionalValue: color, withName: "color")
		addFormData(formData: formData, optionalValue: openDate, withName: "openDate")
		addFormData(formData: formData, optionalValue: isFav, withName: "isFav")
		addFormData(formData: formData, optionalValue: price, withName: "price")
		addFormData(formData: formData, optionalValue: locationId, withName: "locationId")
		
		AF.upload(multipartFormData: formData, to: url, headers: headers).response { response in
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200..<300:
					do {
						guard let data = response.data else { return }
						let root = try JSONDecoder().decode(ItemRoot.self, from: data)
						self.isShowingAlert = true
						self.message = root.message
					} catch let error {
						self.isShowingAlert = true
						self.message = "에러가 발생했습니다.\n\(error.localizedDescription)"
					}
				case 300..<600:
					self.isShowingAlert = true
					if let data = response.data {
						do {
							let apiError = try JSONDecoder().decode(ApiResponse.self, from: data)
							self.message = apiError.message
						} catch let error {
							self.message = error.localizedDescription
						}
					}
				default:
					self.isShowingAlert = true
					self.message = "서버 연결에 실패했습니다.\n잠시 후 다시 시도해주세요."
				}
			}
		}
	}
	
	
	//MARK: - 2. Read Items
	
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
	
	/// 2-2. Find All Items By HomeId
	func fetchAllItem() async {
		let url = "\(endPoint)/items/allItem/\(homeId)"
		do {
			let response = try await AF.request(url, method: .get)
				.serializingDecodable(ItemResponse.self).value
			DispatchQueue.main.async {
				self.items = response.documents
			}
			log("fetchAllItem Complete", trait: .success)
		} catch {
			log("fetchAllItem Error: \(error.localizedDescription)", trait: .error)
		}
	}
	
	/// 2-3. Read Fav Items (All location)
	func fetchFavItems() async {
		let url = "\(endPoint)/items/fav/\(homeId)"
		do {
			let response = try await AF.request(url,method: .get).serializingDecodable(ItemResponse.self).value
			DispatchQueue.main.async { self.favItems = response.documents }
			log("fetchFavItems Complete", trait: .success)
		} catch {
			log("fetchFavItems Error: \(error.localizedDescription)", trait: .error)
		}
	}
	
	//FIXME: -Update Item Optional Field
	//MARK: - 3. Update Item (** patch)
	func editItem(itemId: Int, itemName: String?, purchaseDate: String?, expiryDate: String?, itemUrl: String?, image: UIImage?, desc: String?, color: String?, price: Int?, openDate: String?, locationId: Int?) {
		
		let url = "\(endPoint)/items/edit/\(itemId)"
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
		AF.upload(multipartFormData: formData, to: url, headers: headers).response { response in
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200..<300:
					do {
						guard let data = response.data else { return }
						let root = try JSONDecoder().decode(ItemRoot.self, from: data)
						self.isShowingAlert = true
						self.message = root.message
					} catch let error {
						self.isShowingAlert = true
						self.message = "에러가 발생했습니다.\n\(error.localizedDescription)"
					}
				case 300..<600:
					self.isShowingAlert = true
					if let data = response.data {
						do {
							let apiError = try JSONDecoder().decode(ApiResponse.self, from: data)
							self.message = apiError.message
						} catch let error {
							self.message = error.localizedDescription
						}
					}
				default:
					self.isShowingAlert = true
					self.message = "서버 연결에 실패했습니다.\n잠시 후 다시 시도해주세요."
					
				}
			}
		}
	}
	
	//MARK: - 4. Delete Item
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
			"isFav": itemFav
		]
		log(" isFav 는 \(!itemFav)에서 \(itemFav)로 변경되어야 함")
		let response = AF.request(url, method: .patch, parameters: params, encoding: JSONEncoding.default).response { response in
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200..<300:
					if let data = response.data {
						do {
							let root = try JSONDecoder().decode(ItemRoot.self, from: data)
							log("root.item.isfav로 변경됨: \(root.item.isFav)")
							self.isShowingAlert = true
							DispatchQueue.main.async {
								self.favItems.append(root.item)
							}
							self.message = root.message
						} catch let error {
							self.isShowingAlert = true
							self.message = error.localizedDescription
						}
					}
				case 300..<500:
					if let data = response.data {
						do {
							let res = try JSONDecoder().decode(ApiResponse.self, from: data)
							self.isShowingAlert = true
							self.message = res.message
						} catch let error {
							self.isShowingAlert = true
							self.message = error.localizedDescription
						}
					}
				default:
					self.isShowingAlert = true
					self.message = "network error"
				}
			}
		}
	}
	
	//MARK: - 추가 사진
	//	@Published var isShowingAlertAddAdditionalPhotos: Bool = false
//	@Published var addAdditionalPhotosMessage: String = ""
	func addAdditionalPhotos(images: [UIImage]?, itemId: Int?) {
		guard let images, let itemId else {return}
		SVProgressHUD.show()
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
							let root = try JSONDecoder().decode(ApiResponse.self, from: data)
							self.isShowingAlertAddAdditionalPhotos = true
							self.addAdditionalPhotosMessage = root.message
							log("addAdditionalPhotos", trait: .success)
						} catch {
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
							self.isShowingAlertAddAdditionalPhotos = true
							self.addAdditionalPhotosMessage = apiError.message
						} catch let error {
							self.isShowingAlertAddAdditionalPhotos = true
							self.addAdditionalPhotosMessage = error.localizedDescription
						}
					}
				default:
					self.isShowingAlertAddAdditionalPhotos = true
					self.message = "네트워크 오류입니다."
				}
			}
		}
		SVProgressHUD.dismiss()
	}
	
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
	
	//MARK: - Search Item
	func searchItem(query: String?) async {
		guard let query = query else { return }
		let url = "\(endPoint)/items/search"
		let params: Parameters = ["homeId": homeId, "query": query]
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
	
	func clearSearchResult() {
		searchResultItems.removeAll()
	}
	
	func setCurrentItem(item: Item) {
		currentItem = item
	}
	
}



