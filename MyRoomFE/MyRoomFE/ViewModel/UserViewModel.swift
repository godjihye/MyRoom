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
	@Published var isLoggedIn = false
	@Published var isLoginError = false
	@Published var isJoinShowing = false
	@Published var isMakeHomeError = false
	@Published var userInfo: User?
	@Published var message: String = ""
	@Published var isHaveHome = true
	
	init() {
		self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
	}
	
	let endPoint = Bundle.main.object(forInfoDictionaryKey: "ENDPOINT") as! String
	
	//MARK: - ME
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
							log("homeId: \(signIn.user.homeId)")
							if let homeId = signIn.user.homeId {
								UserDefaults.standard.set(homeId, forKey: "homeId")
							} else {
								self.isHaveHome = false
							}
							log("UserDefaults.standard : \(UserDefaults.standard.integer(forKey: "homeId"))")
						} catch let error {
							self.isLoginError = true
							self.message = error.localizedDescription
						}
					}
				case 300..<600:
					self.isLoginError = true
					if let data = response.data {
						do {
							let apiError = try JSONDecoder().decode(ApiResponse.self, from: data)
							self.message = apiError.message
						} catch let error {
							self.message = error.localizedDescription
						}
					}
				default:
					self.isLoginError = true
					self.message = "서버 연결에 실패했습니다.\n잠시 후 다시 시도해주세요."
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
	func signUp(userName: String, password: String, nickname: String) {
		SVProgressHUD.show()
		let url = "\(endPoint)/users/sign-up"
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
							let apiError = try JSONDecoder().decode(ApiResponse.self, from: data)
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
	func deleteUser(userId: Int) {
		let url = "\(endPoint)/users/\(userId)"
		AF.request(url, method: .delete).response { response in
			guard let statusCode = response.response?.statusCode else { return }
			switch statusCode{
			case 200..<300:
				self.message = "회원 탈퇴가 완료되었습니다."
			default:
				self.message = "회원 탈퇴에 실패했습니다."
			}
		}
	}
	
	// 4. fetch User
	func fetchUser() {
		let url = "\(endPoint)/users"
		let userId = UserDefaults.standard.integer(forKey: "userId")
		log("userId: \(userId)")
		let params: Parameters = ["userId": userId]
	}
	//MARK: - HOME
	// 1. Create Home
	func makeHome(homeName: String, homeDesc: String?) {
		SVProgressHUD.show()
		let userId = UserDefaults.standard.value(forKey: "userId") as! Int
		let url = "\(endPoint)/home/\(userId)"
		let params: Parameters = ["homeName": homeName, "homeDesc": homeDesc ?? ""]

		AF.request(url, method: .post, parameters: params).response { response in
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200..<300:
					if let data = response.data {
						do {
							let home = try JSONDecoder().decode(Home.self, from: data)
							UserDefaults.standard.set(home.id, forKey: "homeId")
							log("home: \(home)")
							//log("homeId: \(self.homeId)")
							self.isHaveHome = true
						} catch let error {
							self.isMakeHomeError = true
							self.message = error.localizedDescription
						}
					}
				case 300..<600:
					self.isMakeHomeError = true
					self.message = "인증 오류입니다."
				default:
					self.isMakeHomeError = true
					self.message = "서버 연결에 실패했습니다.\n잠시 후 다시 시도해주세요."
				}
			}
			SVProgressHUD.dismiss()
		}
	}
	// 2. Join Home With InviteCode
	func joinHome(inviteCode: String?) {
		let userId = UserDefaults.standard.integer(forKey: "userId")
		let url = "\(endPoint)/home/inviteCode/\(userId)"
		let params: Parameters = ["inviteCode": inviteCode]
		AF.request(url, method: .post, parameters: params).response { response in
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200..<300:
					if let data = response.data{
						do {
							let root = try JSONDecoder().decode(HomeRoot.self, from: data)
							UserDefaults.standard.set(root.home.id, forKey: "homeId")
							self.message = root.message
						} catch let error {
							self.isMakeHomeError = true
							self.message = error.localizedDescription
						}
					}
				case 300..<600:
					self.isMakeHomeError = true
					self.message = "집을 찾을 수 없습니다."
				default:
					self.isMakeHomeError = true
					self.message = "서버 연결에 실패했습니다.\n잠시 후 다시 시도해주세요."
					
				}
			}
		}
	}
	
}
