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
        @Published var searchResultUsed: [Used] = []
        
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
                                                
                                                //                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                                                //                            print("JSON response: \(json)") }
                                                
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
                //        AF.request(url).responseDecodable(of: UsedRoot.self) { response in
                //            print(response)
                //        }
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
        func toggleFavorite(userId:Int, usedId:Int,isFavorite:Bool) async {
                
                let url = "\(endPoint)/useds/\(usedId)/favorite"
                let method: HTTPMethod = isFavorite ? .post : .delete
                let action = isFavorite ? "add" : "remove"
                let params:Parameters = ["action":action,"userId":userId]
                
                AF.request(url,method: method,parameters: params, encoding: JSONEncoding.default).response { response in
                        switch response.result {
                        case .success:
                                log("UsedToggleFavorite Complete ", trait: .success)
                        case .failure(let error):
                                log("UsedToggleFavorite: \(error.localizedDescription)", trait: .error)
                        }
                }
        }
        
        //판매상태변화
        func updateUsedStatus(usedStatus:Int,usedId:Int) async {
                guard usedStatus != self.useds.first(where: { $0.id == usedId })?.usedStatus else {
                                return
                }
                
                let url = "\(endPoint)/useds/\(usedId)/status"
                let params:Parameters = ["usedStatus":usedStatus]
                
                do {
                        let response = try await AF.request(url, method: .put,parameters: params, encoding: JSONEncoding.default).serializingData().value
                        DispatchQueue.main.async {
                                if let index = self.useds.firstIndex(where: { $0.id == usedId }) {
                                        self.useds[index].usedStatus = usedStatus
                                }
                        }
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
                //        AF.request(url).responseDecodable(of: Used.self) { response in
                //            print(response)
                //        }
        }
        
        //글 수정
        func updateUsed(usedId:Int,newTitle:String,newPrice:Int,newContent:String,newItem: Item?) async {
                let usedData: [String: Any?] = [
                        "usedTitle": newTitle,
                        "usedPrice": newPrice,
                        "usedDesc": newContent
                        
                ]
                
                let filteredUsedData = usedData.compactMapValues { $0 }
                
                guard let usedDataJson = try? JSONSerialization.data(withJSONObject: filteredUsedData, options: []) else {
                        print("Failed to encode usedData to JSON")
                        return
                }
                
                let formData = MultipartFormData()
                formData.append(usedDataJson, withName: "usedData", mimeType: "application/json")
                
                let url = "\(endPoint)/useds/edit/\(usedId)"
                let headers: HTTPHeaders = [
                        "Content-Type": "multipart/form-data"
                ]
                AF.upload(multipartFormData: formData, to: url,headers: headers).response { response in
                        switch response.result {
                        case .success:
                             print()
                        case .failure(let error):
                                print("Error: \(error.localizedDescription)")
                        }
                        
                }
        }
        
        //글 삭제
        func removeUsed(usedId:Int) async {
                let url = "\(endPoint)/useds/\(usedId)"
                do {
                        AF.request(url, method: .delete)
                                .response { response in
                                        if let data = response.data {
                                                do {
                                                        let root = try JSONDecoder().decode(UsedRoot.self, from: data)
                                                        self.isAddShowing = true
                                                        self.message = root.message
                                                        DispatchQueue.main.async {
                                                                self.useds.removeAll(where: { $0.id == usedId })
                                                        }
                                                } catch let error {
                                                        self.isAddShowing = true
                                                        self.message = error.localizedDescription
                                                }
                                        }
                                }
                        log("removeUsed Complete! ", trait: .success)
                        return
                } catch {
                        log("removeUsed Error: \(error.localizedDescription)", trait: .error)
                }
        }
        
        func searchUsed(query: String?) async {
                guard let query = query else { return }
                let url = "\(endPoint)/useds/search"
                let params: Parameters = ["userId" : userId,"query": query]
                do {
                        let response = try await AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).serializingDecodable(UsedRoot.self).value
                        DispatchQueue.main.async { self.searchResultUsed = response.useds }
                } catch {
                        if let afError = error as? AFError {
                                log("AFError: \(afError.localizedDescription)", trait: .error)
                        } else {
                                log("UnexpectedError: \(error.localizedDescription)", trait: .error)
                        }
                }
                
                                AF.request(url).responseDecodable(of: UsedRoot.self) { response in
                                        print(response)
                                }
        }
        
        func clearSearchResult() {
                searchResultUsed.removeAll()
        }
}
