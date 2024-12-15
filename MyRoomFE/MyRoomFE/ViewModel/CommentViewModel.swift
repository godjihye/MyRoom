//
//  CommentViewModel.swift
//  MyRoomFE
//
//  Created by 이수정 on 12/10/24.
//

import SwiftUI
import Alamofire


class CommentViewModel: ObservableObject {
    @Published var comments:[Comment]=[]  //무한스크롤


    @Published var message = ""
    @Published var isAlertShowing = false
    @Published var isAddShowing = false
    @Published var isFetchError = false
    private var isLoading = false

    let endPoint = Bundle.main.object(forInfoDictionaryKey: "ENDPOINT") as! String
    let userId = UserDefaults.standard.value(forKey: "userId") as! Int
    
    func fetchComment(postId:Int) async {
        guard !isLoading else { return }
        isLoading = true
        let url = "\(endPoint)/comments/\(postId)"
        
        AF.request(url,method:.get).response { response in
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 200..<300:
                    if let data =
                        response.data {
                        do {
                            let root = try JSONDecoder().decode(CommentRoot.self, from: data)
                            DispatchQueue.main.async {
                                self.comments.append(contentsOf: root.comments)
                            }
                                                    
                        }catch let error{
                            self.isAlertShowing = true
                            self.message = error.localizedDescription
                            log("fetchComment UnexpectedError: \(error.localizedDescription)", trait: .error)
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
//                SVProgressHUD.dismiss()
            }
        }
    }
    
    //MARK: 댓글 등록
    func addComment(comment:String,postId:Int,userId:Int) async {
        if comment.isEmpty {
            self.isAlertShowing = true
            self.message = "댓글을 작성해주세요"
        }
        let url = "\(endPoint)/comments/\(postId)/\(userId)"
        let params: Parameters = ["comment" : comment,"parentId" : ""]
        do {
            let response = try await AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).serializingData().value
            log("addComment Complete", trait: .success)
        } catch {
            if let afError = error as? AFError {
                log("addComment AF Error! \(afError)", trait: .error)
            } else {
                log("addComment Unexpected Error: \(error)", trait: .error)
            }
        }
    }
    
    
    //MARK: 대댓글 등록
    func addReples(comment:String,postId:Int,userId:Int,parentId:Int) async {
        if comment.isEmpty {
            self.isAlertShowing = true
            self.message = "댓글을 작성해주세요"
        }
        
        let url = "\(endPoint)/comments/reply/\(parentId)/\(postId)/\(userId)"
        let params: Parameters = ["comment" : comment]
        
        do {
            let response = try await AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).serializingData().value
            log("addComment Complete", trait: .success)
        } catch {
            if let afError = error as? AFError {
                log("addComment AF Error! \(afError)", trait: .error)
            } else {
                log("addComment Unexpected Error: \(error)", trait: .error)
            }
        }
    }
}
