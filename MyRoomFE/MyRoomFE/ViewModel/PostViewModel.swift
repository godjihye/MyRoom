//
//  PostViewModel.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//

import SwiftUI
import Alamofire
import SVProgressHUD



class PostViewModel:ObservableObject {
    @Published var posts:[Post]=[]  //무한스크롤
    @Published var images:[String] = []
    @Published var searchResultPost: [Post] = []
    
    
    //postAddView
    @Published var buttonPositions: [[CGPoint]] = [] // 각 이미지별 버튼 위치 배열
    @Published var buttonItemUrls: [[String]] = [] //각 버튼별 itemUrl 배열
    
    @Published var message = ""
    @Published var isAlertShowing = false
    @Published var isAddShowing = false
    @Published var isFetchError = false
    private var isLoading = false
    
    let endPoint = Bundle.main.object(forInfoDictionaryKey: "ENDPOINT") as! String
    let userId = UserDefaults.standard.value(forKey: "userId") as! Int
    
    var page = 1
    
    //커뮤니티 등록
    func addPost(selectedImages:[UIImage], postTitle:String, postContent:String,selectItemUrl:[[String]]?,buttonPositions:[[CGPoint]]? )  {
        let postData: [String:Any?] = [
            "postTitle" : postTitle,
            "postContent" : postContent,
            "userId" : userId,
            
        ]
        
        
        guard let postDataJson = try? JSONSerialization.data(withJSONObject: postData, options: []) else {
            print("Failed to encode usedData to JSON")
            return
        }
        
        //buttonData 처리
        var postButtonData: [[String: Any]] = []
        
        if let itemUrls = selectItemUrl, let positions = buttonPositions,
           itemUrls.count == positions.count {
            
            for (index, urls) in itemUrls.enumerated() {
                for (buttonIndex, itemUrl) in urls.enumerated() {
                    if positions.indices.contains(index),
                       positions[index].indices.contains(buttonIndex) {
                        let position = positions[index][buttonIndex]
                        postButtonData.append([
                            "positionX": "\(position.x)",
                            "positionY": "\(position.y)",
                            "itemUrl": itemUrl
                        ])
                    }
                }
            }
        }
        
        guard let postButtonDataJson = try? JSONSerialization.data(withJSONObject: postButtonData, options: []) else {
            print("Failed to encode postButtonData to JSON")
            return
        }
        
        let formData = MultipartFormData()
        formData.append(postDataJson, withName: "postData",mimeType: "application/json")
        formData.append(postButtonDataJson, withName: "buttonData", mimeType: "application/json")
        
        for (index, image) in selectedImages.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                formData.append(imageData,
                                withName: "image",
                                fileName: "image_\(UUID().uuidString).jpeg",
                                mimeType: "image/jpeg")
                if index == 0 {formData.append(imageData, withName: "postThumbnail",fileName: "thumbnail_\(UUID().uuidString).jpeg",mimeType: "image/jpeg") }
            }
        }
        
        
        
        let postUrl = "\(endPoint)/posts"
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data"
        ]
        AF.upload(multipartFormData: formData, to: postUrl,headers: headers).response { response in
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 200..<300:
                    if let data =
                        response.data {
                        do {
                            let root = try JSONDecoder().decode(PostRoot.self, from: data)
                            DispatchQueue.main.async {
                                self.posts.append(contentsOf: root.posts)
                            }
                            self.isAddShowing = true
                            self.message = root.message
                            log("addPost Complete", trait: .success)
                        }catch let error{
                            self.isAlertShowing = true
                            self.message = error.localizedDescription
                            log("addPost UnexpectedError: \(error.localizedDescription)", trait: .error)
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
            }
        }
        AF.request(postUrl).responseDecodable(of: PostRoot.self) { response in
                    print(response)
                }
        
    }
    
    
    // 커뮤니티 검색
    func fetchPosts(size:Int = 10)   {
        print("fetchPosts start===========")
        guard !isLoading else { return }
        isLoading = true
        let postUrl = "\(endPoint)/posts/\(userId)"
        let params:Parameters = ["page":self.page, "size":size]
        
        AF.request(postUrl,method:.get,parameters: params).response { response in
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 200..<300:
                    if let data =
                        response.data {
                        do {
                            let root = try JSONDecoder().decode(PostRoot.self, from: data)
                            DispatchQueue.main.async {
                                self.posts.append(contentsOf: root.posts)
                            }
                            self.page += 1
                            if self.posts.isEmpty {
                                self.isAlertShowing = true
                                self.message = "커뮤니티 게시글이 없습니다"
                            }
                            log("fetchPosts Complete", trait: .success)
                        }catch let error{
                            self.isAlertShowing = true
                            self.message = error.localizedDescription
                            log("fetchPosts UnexpectedError: \(error.localizedDescription)", trait: .error)
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
    }
    
    //좋아요
    func toggleFavorite(postId:Int,userId:Int,isFavorite:Bool, completion: @escaping (Bool) -> Void) async {
        print("post toggle gogo11")
        let postFavUrl = "\(endPoint)/posts/\(postId)/favorite"
        
        let method: HTTPMethod = isFavorite ? .post : .delete
        let action = isFavorite ? "add" : "remove"
        let params:Parameters = ["action":action,"userId":userId]
        
        AF.request(postFavUrl,method: method,parameters: params, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success:
                completion(true) // 성공 시 true 전달
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(false) // 실패 시 false 전달
            }
        }
    }
    
    //조회수 증가
    func updateViewCnt(postId:Int) async {
        let url = "\(endPoint)/posts/\(postId)/viewCnt"
        do {
            let response = try await AF.request(url, method: .post, encoding: JSONEncoding.default).serializingData().value
            log("postUpdateViewCnt Complete! \(response.description)", trait: .success)
        } catch {
            log("postUpdateViewCnt Error: \(error.localizedDescription)", trait: .error)
        }
        
    }
    
    // 글삭제
    func removePost(postId:Int)  {
        let url = "\(endPoint)/posts/\(postId)"
        do {
            AF.request(url, method: .delete)
                .response { response in
                    if let data = response.data {
                        do {
                            let root = try JSONDecoder().decode(PostRoot.self, from: data)
                            self.isAddShowing = true
                            self.message = root.message
                            DispatchQueue.main.async {
                                self.posts.removeAll(where: { $0.id == postId })
                            }
                        } catch let error {
                            self.isAddShowing = true
                            self.message = error.localizedDescription
                        }
                    }
                }
            log("removePost Complete! ", trait: .success)
            return
        } catch {
            log("removePost Error: \(error.localizedDescription)", trait: .error)
        }
    }
    
    func searchPost(query: String?) async {
        guard let query = query else { return }
        let url = "\(endPoint)/posts/search"
        let params: Parameters = ["userId" : userId,"query": query]
        do {
            let response = try await AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).serializingDecodable(PostRoot.self).value
            DispatchQueue.main.async { self.searchResultPost = response.posts }
        } catch {
            if let afError = error as? AFError {
                log("AFError: \(afError.localizedDescription)", trait: .error)
            } else {
                log("UnexpectedError: \(error.localizedDescription)", trait: .error)
            }
        }
        
        AF.request(url).responseDecodable(of: PostRoot.self) { response in
            print(response)
        }
    }
    
    func clearSearchResult() {
        searchResultPost.removeAll()
    }
    
    
    
}
