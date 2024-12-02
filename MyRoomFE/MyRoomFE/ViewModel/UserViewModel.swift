//
//  UserViewModel.swift
//  MyRoomFE
//
//  Created by jhshin on 11/19/24.
//

import Foundation
import Alamofire
import SwiftUI
import SVProgressHUD

class UserViewModel: ObservableObject {
	@AppStorage("userInfo-token") var token: String = ""
	@AppStorage("userInfo-userName") var userName: String = ""
	@AppStorage("userInfo-userId") var userId: Int?
	//@AppStorage("isLoggedIn") var isLoggedIn: Bool = false
	
	@Published var isLoggedIn = false
	@Published var isLoginError = false
	@Published var message: String = ""
	@Published var isJoinShowing = false
	init() {
		self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
	}
	let endPoint = Bundle.main.object(forInfoDictionaryKey: "ENDPOINT") as! String
	
	// 1. Login
	func login(userName: String, password: String) {
		SVProgressHUD.show()
		let url = "\(endPoint)/users/sign-in"
		let param: Parameters = ["userName": userName, "password": password]
		AF.request(url, method: .post, parameters: param).response { response in
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200..<300:
					if let data = response.data {
						do {
							let signIn = try JSONDecoder().decode(SignIn.self, from: data)
							self.isLoggedIn = true
							UserDefaults.standard.set(signIn.token, forKey: "token")
							UserDefaults.standard.set(signIn.user.userName, forKey: "userName")
							UserDefaults.standard.set(signIn.user.id, forKey: "userId")
							UserDefaults.standard.set(self.isLoggedIn, forKey: "isLoggedIn")
						} catch let error {
							self.isLoginError = true
							self.message = error.localizedDescription
						}
					}
				case 300..<600:
					self.isLoginError = true
					if let data = response.data {
						do {
							let apiError = try JSONDecoder().decode(APIError.self, from: data)
							self.message = apiError.message
						} catch let error {
							self.message = error.localizedDescription
						}
					}
				default:
					self.isLoginError = true
					self.message = "알 수 없는 에러 발생"
				}
			}
		}
		SVProgressHUD.dismiss()
	}
	
	// 1-1. Logout
	func logout() {
		isLoggedIn = false
		UserDefaults.standard.removeObject(forKey: "token")
		UserDefaults.standard.removeObject(forKey: "userName")
		UserDefaults.standard.removeObject(forKey: "userId")
		UserDefaults.standard.removeObject(forKey: "isLoggedIn")
	}
	
	// 2. Register
	func signUp(userName: String, password: String, nickname: String, userImage: UIImage?) {
		SVProgressHUD.show()
		let url = "\(endPoint)/users/sign-up"
		let imageData = "https://i.namu.wiki/i/gFiTKAiwlIlaSHvSQkyUO5cN2mjSve57OKhUN2kxSCMKvoipTcwNXZlVxdx1run5YDssHaPi6WX9wwGUHhWL_OjNFwjCt-R4QtY2TND7-2bHZI_D4flEPRfdLoIG2vUx5RZvUlBBU_qbjOvAqgFgxg.webp"
		let params: Parameters = ["userName": userName, "password": password, "nickname": nickname]
		
		AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).response { response in
			if let statusCode = response.response?.statusCode {
				self.isJoinShowing = true
				switch statusCode {
				case 200..<300:
					if let data = response.data {
						do {
							let signUp = try JSONDecoder().decode(SignUp.self, from: data)
							self.message = signUp.message
						}
						catch let error {
							self.message = error.localizedDescription
						}
					}
				case 300..<600:
					if let data = response.data {
						do {
							let apiError = try JSONDecoder().decode(APIError.self, from: data)
							self.message = apiError.message
						} catch let error{
							self.message = error.localizedDescription
						}
					}
				default:
					self.message = "알 수 없는 에러 발생"
				}
			}
		}
		SVProgressHUD.dismiss()
	}
	
	// 3. 회원 탈퇴
	func deleteUser(userId: Int){}
	
}
