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
    var page = 1
    @AppStorage("token") var token:String?
    let endPoint = Bundle.main.object(forInfoDictionaryKey: "ENDPOINT") as! String

    let userId = UserDefaults.standard.value(forKey: "userId") as! Int
    
    func fetchUseds(size:Int = 10) {
        
        guard !isLoading else { return }
        isLoading = true
        let url = "\(endPoint)/useds/\(userId)"
        //        guard let token = self.token else { return }
        let params:Parameters = ["page":self.page, "size":size]
        //        let headers:HTTPHeaders = ["Authorization": "Bearer \(token)"]
  
        AF.request(url,method: .get,parameters: params).response { response in
            defer {
                    self.isLoading = false
                    SVProgressHUD.dismiss()
                }
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 200..<300:
                    if let data = response.data {
                        
                        //						if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        //							print("JSON response: \(json)") }
                        
                        do {
                            let root = try JSONDecoder().decode(UsedRoot.self, from: data)
                            DispatchQueue.main.async {
                                self.useds.append(contentsOf: root.useds)
                            }
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
                            let apiError = try JSONDecoder().decode(APIError.self, from: data)
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
                self.isLoading = false
                SVProgressHUD.dismiss()
            }
        }
        //		AF.request(url).responseDecodable(of: UsedRoot.self) { response in
        //			print(response)
        //		}
    }
    
    // 글상세
    func fetchDetailUsed(usedId : Int,userId:Int) async throws -> Used{
        let url = "\(endPoint)/useds/detail/\(usedId)/\(userId)"
        do {
            let response = try await AF.request(url, method: .get, encoding: JSONEncoding.default).serializingData().value
            
            // JSON 디코딩
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let usedDetail = try decoder.decode(Used.self, from: response)
            
            log("fetchDetailUsed Complete! \(usedDetail)", trait: .success)
            return usedDetail
        } catch {
            log("fetchDetailUsed Error: \(error.localizedDescription)", trait: .error)
            throw error
        }
    }
    
    //좋아요
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
                    log("UsedToggleFavorite Complete ", trait: .success)
                case .failure(let error):
                    completion(false) // 실패 시 false 전달
                    log("UsedToggleFavorite: \(error.localizedDescription)", trait: .error)
                }
            }
        }
    
    //판매상태변화
    func updateUsedStatus(usedStatus:Int,usedId:Int) async {
        
        let url = "\(endPoint)/useds/\(usedId)/status"
        let params:Parameters = ["usedStatus":usedStatus]
        
        do {
            let response = try await AF.request(url, method: .put,parameters: params, encoding: JSONEncoding.default).serializingData().value
            log("updatUsedeStatus Complete! \(response.description)", trait: .success)
        } catch {
            log("updatUsedeStatus Error: \(error.localizedDescription)", trait: .error)
        }
    }
    
    //조회수 증가
    func updateViewCnt(usedId:Int) async {
        let url = "\(endPoint)/useds/\(usedId)/viewCnt"
        do {
            let response = try await AF.request(url, method: .post, encoding: JSONEncoding.default).serializingData().value
            log("updateViewCnt Complete! \(response.description)", trait: .success)
        } catch {
            log("updateViewCnt Error: \(error.localizedDescription)", trait: .error)
        }
        
    }
    
    // 글 등록
    func addUsed(selectedImages:[UIImage],usedTitle:String,usedPrice:Int,usedContent:String,selectMyItem:Item?,completion: @escaping (Bool) -> Void) {
        let usedData: [String: Any?] = [
            "usedTitle": usedTitle,
            "usedPrice": usedPrice,
            "usedDesc": usedContent,
            "usedPurchaseDate": selectMyItem?.purchaseDate,
            "usedExpiryDate": selectMyItem?.expiryDate,
            "usedOpenDate": selectMyItem?.openDate,
            "purchasePrice": selectMyItem?.price,
            "itemName" : selectMyItem?.itemName,
            "itemDesc" : selectMyItem?.desc,
			"userId" : userId,
            "usedUrl" :selectMyItem?.url,
        ]
        
        let filteredUsedData = usedData.compactMapValues { $0 }
        
        guard let usedDataJson = try? JSONSerialization.data(withJSONObject: filteredUsedData, options: []) else {
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
        
        let url = "\(endPoint)/useds"
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data"
        ]
        AF.upload(multipartFormData: formData, to: url,headers: headers).response { response in
            switch response.result {
            case .success:
                completion(true) // 성공 시 true 전달
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(false) // 실패 시 false 전달
            }
            
        }
        //		AF.request(url).responseDecodable(of: Used.self) { response in
        //			print(response)
        //		}
    }
}

