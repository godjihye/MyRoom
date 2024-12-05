//
//  UsedViewModel.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/19/24.
//

import SwiftUI
import Alamofire
import SVProgressHUD

class UsedViewModel:ObservableObject {
	@Published var useds:[Used]=[]
	@Published var images:[String] = []
	//    @Published var usedPhoto:UsedPhotos
	@Published var message = ""
	@Published var isAlertShowing = false
	@Published var isAddShowing = false
	@Published var isFetchError = false
	private var isLoading = false
	private var page = 1
	@AppStorage("token") var token:String?
	let endPoint = "http://localhost:3000"

	func fetchUseds() {
		//        guard !isLoading else { return }
		//        isLoading = true
		let url = "\(endPoint)/useds/4?page=1&pageSize=10"
		//        guard let token = self.token else { return }
		//        let params:Parameters = ["page":self.page, "size":size]
		//        let headers:HTTPHeaders = ["Authorization": "Bearer \(token)"]
		
		AF.request(url,method: .get).response { response in
			
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200..<300:
					if let data = response.data {
						
						if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
							print("JSON response: \(json)") }
						
						do {
							let root = try JSONDecoder().decode(UsedRoot.self, from: data)
							self.useds.append(contentsOf: root.useds)
							self.page += 1
							if self.useds.isEmpty {
								self.isAlertShowing = true
								self.message = "useds등록된 상품이 없습니다."
							}
						} catch let error {
							print(error.localizedDescription)
							self.isAlertShowing = true
							self.message = error.localizedDescription
						}
					}
				case 300..<500:
					if let data = response.data {
						do {
							self.isAlertShowing = true
							let apiError = try JSONDecoder().decode(ApiResponse.self, from: data)
							self.message = apiError.message
						} catch let error {
							self.isAlertShowing = true
							self.message = error.localizedDescription
						}
					}
				default:
					self.isAlertShowing = true
					self.message = "네트워크 오류입니다."
				}
			}
		}
		AF.request(url).responseDecodable(of: UsedRoot.self) { response in
			print(response)
		}
	}
	
	func toggleFavorite(userId:Int, usedId:Int,isFavorite:Bool, completion: @escaping (Bool) -> Void) {
		print("toggke gogo")
		let url = "\(endPoint)/useds/\(usedId)/favorite"
		let method: HTTPMethod = isFavorite ? .delete : .post
		let action = isFavorite ? "remove" : "add"
		let params:Parameters = ["action":action,"userId":userId]
		
		AF.request(url,method: method,parameters: params, encoding: JSONEncoding.default).response { response in
			switch response.result {
			case .success:
				completion(true) // 성공 시 true 전달
			case .failure(let error):
				print("Error: \(error.localizedDescription)")
				completion(false) // 실패 시 false 전달
			}
		}
	}
	
	func addUsed(selectedImages:[UIImage],usedTitle:String,usedPrice:Int,usedContent:String,selectMyItem:[String]) {
		let usedData: [String: Any] = [
			"usedTitle": usedTitle,
			"usedPrice": usedPrice,
			"usedDesc": usedContent,
			"usedPurchaseDate": selectMyItem[0],
			"usedExpiryDate": selectMyItem[1],
			"usedOpenDate": selectMyItem[2],
			"purchasePrice": selectMyItem[3],
			"itemName" : selectMyItem[4],
			"itemDesc" : selectMyItem[5],
			"userId" : 4,
			"usedUrl" :selectMyItem[7],
		]
		guard let usedDataJson = try? JSONSerialization.data(withJSONObject: usedData, options: []) else {
			print("Failed to encode usedData to JSON")
			return
		}
		let formData = MultipartFormData()
		formData.append(usedDataJson, withName: "usedData", mimeType: "application/json")
		for (index, image) in selectedImages.enumerated() {
			if let imageData = image.jpegData(compressionQuality: 0.8) {
				formData.append(imageData,
												withName: "image",
												fileName: "image_\(UUID().uuidString).jpeg",
												mimeType: "image/jpeg")
				if index == 0 {formData.append(imageData, withName: "usedThumbnail",fileName: "thumbnail_\(UUID().uuidString).jpeg",mimeType: "image/jpeg") }
			}
		}
		print("Form Data: \(formData)")
		let url = "\(endPoint)/useds"
		let headers: HTTPHeaders = [
			"Content-Type": "multipart/form-data"
		]
		AF.upload(multipartFormData: formData, to: url,headers: headers).response { response in
			print("update start \(response)")
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200..<300:
					if let data = response.data {
						if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
							print("JSON response: \(json)") }
						do {
							let root = try JSONDecoder().decode(UsedRoot.self, from: data)
						} catch let error {
							print("200err : \(error.localizedDescription)")
							self.isAlertShowing = true
							self.message = error.localizedDescription
						}
					}
				case 300..<500:
					if let data = response.data {
						if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
							print("JSON response: \(json)") }
						do {
							self.isAlertShowing = true
							let apiError = try JSONDecoder().decode(ApiResponse.self, from: data)
							self.message = apiError.message
						} catch let error {
							self.isAlertShowing = true
							print("500err : \(error.localizedDescription)")
							self.message = error.localizedDescription
						}
					}
				default:
					self.isAlertShowing = true
					self.message = "네트워크 오류입니다."
				}
			}
		}
		AF.request(url).responseDecodable(of: UsedRoot.self) { response in
			print(response)
		}
	}
}

