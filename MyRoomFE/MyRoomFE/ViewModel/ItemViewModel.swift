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
	
	@Published var isAddShowing: Bool = false
	@Published var isRemoveShowing: Bool = false
	@Published var isEditShowing: Bool = false
	@Published var searchResultItems: [Item] = []
	@Published var searchResultItemsByName: [Item] = []
	@Published var searchResultItemsByImageText: [Item] = []
	
	// ALERT STATE VARIABLES
	@Published var isShowingAlertAddAdditionalPhotos: Bool = false
	@Published var addAdditionalPhotosMessage: String = ""
	@Published var isShowingAlertRemoveAdditionalPhotos: Bool = false
	@Published var removeAdditionalPhotosMessage: String = ""
	
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
						let item = root.item
						self.items.append(item)
					} catch let error {
						self.isShowingAlert = true
						self.message = "에러가 발생했습니다.\n\(error.localizedDescription)"
					}
				case 300..<600:
					self.isShowingAlert = true
					if let data = response.data {
						do {
							let apiError = try JSONDecoder().decode(APIError.self, from: data)
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
	func fetchAllItem(filterByItemUrl:Bool) async -> [Item]  {
		let url = "\(endPoint)/items/allItem/\(homeId)"
		let params:Parameters = ["filterByItemUrl":filterByItemUrl]
		do {
			let response = try await AF.request(url, method: .get,parameters: params)
				.serializingDecodable(ItemResponse.self).value
			return response.documents
			//			DispatchQueue.main.async {
			//				self.allItems = response.documents
			//			}
			log("fetchAllItem Complete", trait: .success)
		} catch {
			log("fetchAllItem Error: \(error.localizedDescription)", trait: .error)
		}
		
		return []
		
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
						self.isEditShowing = true
						self.message = root.message
						if let index = self.items.firstIndex(where: { $0.id == root.item.id}) {
							self.items[index] = root.item
						}
					} catch let error {
						self.isEditShowing = true
						self.message = "에러가 발생했습니다.\n\(error.localizedDescription)"
					}
				case 300..<600:
					self.isShowingAlert = true
					if let data = response.data {
						do {
							let apiError = try JSONDecoder().decode(APIError.self, from: data)
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
	func removeItem(itemId: Int) {
		let url = "\(endPoint)/items/\(itemId)"
		AF.request(url, method: .delete).response { response in
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200..<300:
					do {
						if let data = response.data {
							let root = try JSONDecoder().decode(APIError.self, from: data)
							self.isRemoveShowing = true
							self.message = root.message
						}
					} catch {
						log("decoding error")
					}
				default:
					log("network error")
				}
			}
		}
		//		do {
		//			let response = try await AF.request(url, method: .delete).serializingData().value
		//			log("removeItem Complete! \(response.description)", trait: .success)
		//		} catch {
		//			log("removeItem Error: \(error.localizedDescription)", trait: .error)
		//		}
	}
	
	// Fav 등록 / 해제
	func updateItemFav(itemId: Int, itemFav: Bool) {
		let url = "\(endPoint)/items/\(itemId)"
		let params: Parameters = [
			"isFav": !itemFav
		]
		AF.request(url, method: .patch, parameters: params, encoding: JSONEncoding.default).response { response in
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200..<300:
					if let data = response.data {
						do {
							let root = try JSONDecoder().decode(ItemRoot.self, from: data)
							log("root.item.isfav로 변경됨: \(root.item.isFav)")
							self.isShowingAlert = true
							self.message = root.message
							if let index = self.items.firstIndex(where: {$0.id == itemId}) {
								self.items[index].isFav = !itemFav
							}
						} catch let error {
							self.isShowingAlert = true
							self.message = error.localizedDescription
						}
					}
				case 300..<500:
					if let data = response.data {
						do {
							let res = try JSONDecoder().decode(APIError.self, from: data)
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
	func addAdditionalPhotos(images: [UIImage]?, texts: [String]?, itemId: Int?) {
		guard let images, let itemId, let texts else {return}
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
		for (index, text) in texts.enumerated() {
			formData.append(text.data(using: .utf8)!, withName: "photoText[\(index)]")
		}
		
		AF.upload(multipartFormData: formData, to: url, method: .post, headers: headers).response { response in
			defer {
				SVProgressHUD.dismiss()
			}
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200..<300:
					if let data = response.data {
						log(String(data: data, encoding: .utf8) ?? "")
						do {
							let root = try JSONDecoder().decode(ItemResponse.self, from: data)
							DispatchQueue.main.async {
									self.isShowingAlertAddAdditionalPhotos = true
									self.addAdditionalPhotosMessage = "추가 사진을 성공적으로 등록했습니다."
							}
							if let index = self.items.firstIndex(where: { $0.id == root.documents.first?.id}) {
								log("if let 구문 안에 들어옴")
								
								if let itemPhoto = root.documents.first?.itemPhoto {
									self.items[index].itemPhoto = itemPhoto
									
								}
							}
							
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
							let apiError = try JSONDecoder().decode(APIError.self, from: data)
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
	}
	
	func removeAdditionalPhoto(photoId: Int) {
		let url = "\(endPoint)/items/additionalPhoto/\(photoId)"
		AF.request(url, method: .delete).response { response in
			guard let statusCode = response.response?.statusCode else { return }
			switch statusCode {
			case 200..<300:
				if let data = response.data {
					log(String(data: data, encoding: .utf8) ?? "")
					do {
						let root = try JSONDecoder().decode(DeleteAdditionalPhotosRoot.self, from: data)
						self.removeAdditionalPhotosMessage = root.message
						self.isShowingAlertRemoveAdditionalPhotos = true
						log("itemId: \(root.itemId)")
						log("id: \(root.id)")
						if let index = self.items.firstIndex(where: { $0.id == root.itemId}) {
							if let photoIndex = self.items[index].itemPhoto?.firstIndex(where: {$0.id == root.id}) {
								self.items[index].itemPhoto?.remove(at: photoIndex)
							}
						}
					} catch {
						log("response decoding error")
					}
				}
				log("removeAdditionalPhotoSuccessfully")
				
			default:
				log("removeAdditionalPhoto Fail", trait: .error)
			}
		}
	}
	
	//MARK: - Search Item
	func searchItem(query: String?) {
		guard let query = query else { return }
		let url = "\(endPoint)/items/search"
		let params: Parameters = ["homeId": homeId, "query": query]
		AF.request(url, method: .post, parameters: params).response { response in
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200..<300:
					do {
						if let data = response.data {
							log(String(data: data, encoding: .utf8) ?? "")
							let root = try JSONDecoder().decode(ItemSearchResultRoot.self, from: data)
							self.searchResultItems = root.items.combinedItems
							if root.items.combinedItems.count == 0 {
								self.isShowingAlert = true
								self.message = "검색 결과가 없습니다."
							}
							self.searchResultItemsByName = root.items.findByName
							self.searchResultItemsByImageText = root.items.findByQuery
						}
					} catch {
						
						log("decode error", trait: .error)
					}
				default:
					log("error", trait: .error)
				}
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



