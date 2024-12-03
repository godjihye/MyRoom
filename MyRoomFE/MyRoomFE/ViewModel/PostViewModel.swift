//
//  PostViewModel.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//

import SwiftUI
import Alamofire




class PostViewModel:ObservableObject {
    @Published var posts:[Post]=[]  //무한스크롤
    @Published var images:[String] = []
    
    @Published var message = ""
    @Published var isAlertShowing = false
    @Published var isAddShowing = false
    @Published var isFetchError = false
    let endPoint = "http://localhost:3000"
    
    private var page = 1
    
    //커뮤니티 등록
    func addPost(selectedImages:[UIImage], postTitle:String, postContent:String ) async {
        let postData: [String:Any?] = [
            "postTitle" : postTitle,
            "postContent" : postContent,
            "userId" : 1
        ]
        
        guard let postDataJson = try? JSONSerialization.data(withJSONObject: postData, options: []) else {
            print("Failed to encode usedData to JSON")
            return
        }
        
        let formData = MultipartFormData()
        formData.append(postDataJson, withName: "postData",mimeType: "application/json")
        
        for (index, image) in selectedImages.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                formData.append(imageData,
                                withName: "image",
                                fileName: "image_\(UUID().uuidString).jpeg",
                                mimeType: "image/jpeg")
                if index == 0 {formData.append(imageData, withName: "postThumbnail",fileName: "thumbnail_\(UUID().uuidString).jpeg",mimeType: "image/jpeg") }
            }
        }
        
        let postRegistUrl = "\(endPoint)/posts"
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data"
        ]
        AF.upload(multipartFormData: formData, to: postRegistUrl,headers: headers).response { response in
            print("postUpdate start \(response)")
            
        }
    }
    
    
    // 커뮤니티 검색
    func fetchPosts() async {
        print("post fetch start===========")
        let postUrl = "\(endPoint)/posts/4?page=1&pageSize=10"
        
        do{
            let reponse = try await AF.request(postUrl,method: .get).serializingDecodable(PostRoot.self).value
            
            if self.posts.isEmpty {
                self.isAlertShowing = true
                self.message = "커뮤니티 게시글이 없습니다"
            }
            
            DispatchQueue.main.async {
                self.posts.append(contentsOf: reponse.posts)
                self.page += 1
            }
            log("fetchPosts Complete", trait: .success)
        }catch{
            if let afError = error as? AFError {
                log("AFError: \(afError.localizedDescription)", trait: .error)
            } else {
                log("UnexpectedError: \(error.localizedDescription)", trait: .error)
            }
        }
        
        AF.request(postUrl).responseDecodable(of: PostRoot.self) { response in
            if let jsonData = response.data {
                if let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) {
                    print("JSON response: \(json)") }
            }
            
            print(response)
        }
    }
    
    //좋아요
    func toggleFavorite(postId:Int,userId:Int,isFavorite:Bool, completion: @escaping (Bool) -> Void) async {
        print("post toggle gogo11")
        let postFavUrl = "\(endPoint)/posts/\(postId)/favorite"
        
        let method: HTTPMethod = isFavorite ? .delete : .post
        let action = isFavorite ? "remove" : "add"
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
        //        do {
        //            let response =  try await AF.request(postFavUrl,method: method, parameters: params, encoding: JSONEncoding.default).serializingDecodable(PostRoot.self).value
        //
        //            print(response)
        //            log("postToggleFavorite Complete ", trait: .success)
        //        } catch {
        //            log("postToggleFavorite: \(error.localizedDescription)", trait: .error)
        //        }
        //
        //        AF.request(postFavUrl).responseDecodable(of: PostRoot.self) { response in
        //            if let jsonData = response.data {
        //                           if let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) {
        //                               print("JSON response: \(json)") }
        //                       }
        //            print(response)
        //        }
        
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
    
}
