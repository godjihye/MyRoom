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
	
	@Published var isLoggedIn: Bool = false
	@Published var isLoginError: Bool = false
	@Published var isJoinShowing: Bool = false
	
	@Published var isMakeHomeAlert: Bool = false
	
	@Published var message: String = ""
	@Published var showAlert: Bool = false
	
	@Published var isHaveHome: Bool = false
	@Published var inviteCode: String = ""
	
	@Published var isShowingChangePW: Bool = false
	@Published var changePWMessage: String = ""
	
	@Published var userInfo: User?
	
	init() {
		self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
	}
	
	let endPoint = Bundle.main.object(forInfoDictionaryKey: "ENDPOINT") as! String
	
	//MARK: - Login / Register
	
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
							UserDefaults.standard.set(signIn.user.userImage, forKey: "userImage")
							UserDefaults.standard.set(signIn.user.nickname, forKey: "nickName")
							if let homeId = signIn.user.homeId {
								UserDefaults.standard.set(homeId, forKey: "homeId")
								if let homeName = signIn.user.homeUser?.homeName {
									UserDefaults.standard.set(homeName, forKey: "homeName")
								}
							} else {
								self.isHaveHome = false
							}
						} catch let error {
							log("decoding Error")
						}
					}
				case 300..<600:
					self.isLoginError = true
					if let data = response.data {
						do {
							let apiError = try JSONDecoder().decode(APIError.self, from: data)
							self.message = apiError.message
						} catch let error {
							log("decoding error")
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
	
	func socialLogin(userName: String) {
		SVProgressHUD.show()
		let url = "\(endPoint)/users/social/login"
		let params: Parameters = ["userName": userName]
		AF.request(url, method: .post, parameters: params).response { response in
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
							UserDefaults.standard.set(signIn.user.userImage, forKey: "userImage")
							UserDefaults.standard.set(signIn.user.nickname, forKey: "nickName")
							if let homeId = signIn.user.homeId {
								UserDefaults.standard.set(homeId, forKey: "homeId")
							}
						} catch let error {
							log("social login decode error: \(error.localizedDescription)")
						}
					}
				case 300..<600:
					self.isLoginError = true
					if let data = response.data {
						do {
							let res = try JSONDecoder().decode(APIError.self, from: data)
							self.message = res.message
						} catch let error {
							log("error : \(error)")
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
							let signUp = try JSONDecoder().decode(UserInfo.self, from: data)
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
	
	func logout() {
		SVProgressHUD.show()
		isLoggedIn = false
		UserDefaults.standard.removeObject(forKey: "token")
		UserDefaults.standard.removeObject(forKey: "userName")
		UserDefaults.standard.removeObject(forKey: "userId")
		UserDefaults.standard.removeObject(forKey: "isLoggedIn")
		UserDefaults.standard.removeObject(forKey: "userImage")
		UserDefaults.standard.removeObject(forKey: "nickName")
		UserDefaults.standard.removeObject(forKey: "homeId")
		UserDefaults.standard.removeObject(forKey: "homeName")
		userInfo = nil
		SVProgressHUD.dismiss()
	}
	
	func fetchUser() {
		let userId = UserDefaults.standard.integer(forKey: "userId")
		let url = "\(endPoint)/users/info/\(userId)"
		AF.request(url, method: .get).response { response in
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200..<300:
					do {
						if let data = response.data {
							log("response.data = \(data.description)")
							let root = try JSONDecoder().decode(UserInfo.self, from: data)
							self.userInfo = root.user
						}
					} catch let error {
						log("decode error: \(error.localizedDescription)")
					}
				case 300..<500:
					log("error: statusCode 300..<500")
				default:
					log("network error")
				}
			}
		}
	}
	
	//MARK: - User Status Change
	// 1. delete
	func deleteUser() {
		
		let userId = UserDefaults.standard.integer(forKey: "userId")
		let url = "\(endPoint)/users/\(userId)"
		
		AF.request(url, method: .delete).response { response in
			do {
				guard let data = response.data else {return}
				let resp = try JSONDecoder().decode(APIError.self, from: data)
				self.showAlert = true
				self.message = resp.message
			} catch {
				log("decode error")
			}
		}
		logout()
	}
	
	func editUser(userImage: UIImage?, nickname: String?) {
		let userId = UserDefaults.standard.integer(forKey: "userId")
		let patchURL = "\(endPoint)/users/\(userId)"
		let headers: HTTPHeaders = ["Content-Type": "multipart/form-data"]
		let formData = MultipartFormData()
		if let userImage, let imageData = userImage.jpegData(compressionQuality: 0.8) {
			formData.append(imageData, withName: "userImage", fileName: "userImage.jpg", mimeType: "image/jpeg")
			log("formData image appended")
		}
		addFormData(formData: formData, optionalValue: nickname, withName: "nickname")
		AF.upload(multipartFormData: formData, to: patchURL, headers: headers).response { response in
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200..<300:
					do {
						guard let data = response.data, let responseString = String(data: data, encoding: .utf8) else {return}
						log("responseString: \(responseString)")
						let root = try JSONDecoder().decode(UserInfo.self, from: data)
						if let userImage = root.user.userImage {
							UserDefaults.standard.set(root.user.userImage, forKey: "userImage")
							self.userInfo?.userImage = userImage
						}
						self.showAlert = true
						self.message = root.message
						self.userInfo?.nickname = root.user.nickname
						
						log("upload image success")
					} catch let error {
						log("decode error: \(error.localizedDescription)")
					}
				case 300..<500:
					log("error: statusCode 300..<500")
				default:
					log("network error")
				}
			}
		}
	}
	func changepw(cpw: String?, npw: String?) {
		SVProgressHUD.show()
		guard let cpw, let npw else { return }
		let userId = UserDefaults.standard.integer(forKey: "userId")
		let url = "\(endPoint)/users/changepw/\(userId)"
		let params: Parameters = ["cpw": cpw, "npw": npw]
		AF.request(url, method: .post, parameters: params).response { response in
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200...500:
					if let data = response.data{
						do {
							let root = try JSONDecoder().decode(APIError.self, from: data)
							self.changePWMessage = root.message
							self.isShowingChangePW = true
						} catch {
							log("Decoding error")
						}
					}
				default:
					log("머징?")
				}
			}
		}
		SVProgressHUD.dismiss()
	}
	
	func deleteMate(userId: Int) {
		let myUserId = UserDefaults.standard.integer(forKey: "userId")
		let url = "\(endPoint)/users/\(userId)"
		let params: [String: Any] = ["homeId": NSNull()]
		AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).response { response in
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200..<300 :
					self.showAlert = true
					if myUserId != userId {
						self.message = "룸메를 방출시켰습니다."
						if let index = self.userInfo?.mates?.firstIndex(where: {$0.id == userId})  {
						 self.userInfo?.mates?.remove(at: index)
					 }
					} else {
						self.message = "집 나가기 성공"
						
						UserDefaults.standard.removeObject(forKey: "homeId")
						UserDefaults.standard.removeObject(forKey: "homeName")
					}
				default:
					self.showAlert = true
					if myUserId != userId {
						self.message = "룸메 방출시키는 데에 실패했습니다."
					} else {
						self.message = "집 나가기 실패"
					}
				}
			}
		}
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
							let root = try JSONDecoder().decode(HomeRoot.self, from: data)
							UserDefaults.standard.set(root.home.id, forKey: "homeId")
							self.showAlert = true
							self.message = "집 등록 성공"
						} catch let error {
							self.showAlert = true
							self.message = error.localizedDescription
						}
					}
				case 300..<600:
					self.showAlert = true
					self.message = "인증 오류입니다."
				default:
					self.showAlert = true
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
		let params: Parameters = ["inviteCode": inviteCode ?? ""]
		AF.request(url, method: .post, parameters: params).response { response in
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200..<300:
					if let data = response.data{
						do {
							let root = try JSONDecoder().decode(HomeRoot.self, from: data)
							UserDefaults.standard.set(root.home.id, forKey: "homeId")
							self.isMakeHomeAlert = true
							self.message = root.message
						} catch let error {
							self.isMakeHomeAlert = true
							self.message = error.localizedDescription
						}
					}
				case 300..<600:
					self.isMakeHomeAlert = true
					self.message = "집을 찾을 수 없습니다."
				default:
					self.isMakeHomeAlert = true
					self.message = "서버 연결에 실패했습니다.\n잠시 후 다시 시도해주세요."
					
				}
			}
		}
	}
	
	// 3. 초대코드 조회
	func getInviteCode() {
		let homeId = UserDefaults.standard.integer(forKey: "homeId")
		guard homeId > 0 else { return }
		log("homeId: \(homeId)")
		let url = "\(endPoint)/home/inviteCode/\(homeId)"
		AF.request(url, method: .get).response { response in
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200..<300:
					if let data = response.data {
						do {
							let code = try JSONDecoder().decode(InviteCode.self, from: data)
							UserDefaults.standard.set(code.inviteCode, forKey: "inviteCode")
							self.inviteCode = code.inviteCode
						} catch {
							log("decode error")
						}
					}
				case 300..<500:
					log("300..<500")
				default:
					log("network error")
				}
			}
		}
	}
	
	// 4. 초대코드 재발행
	func refreshInviteCode() {
		let homeId = UserDefaults.standard.integer(forKey: "homeId")
		let url = "\(endPoint)/home/inviteCode/refresh/\(homeId)"
		AF.request(url, method: .get).response { response in
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200..<300:
					if let data = response.data {
						do {
							let res = try JSONDecoder().decode(InviteCode.self, from: data)
							self.inviteCode = res.inviteCode
						} catch let error {
							log("decode error: \(error)")
						}
					}
				case 300..<500:
					log("statusCode is 300..<500")
				default:
					log("success")
				}
			}
		}
	}
	func deleteHome() {
		let homeId = UserDefaults.standard.integer(forKey: "homeId")
		let url = "\(endPoint)/home/\(homeId)"
		AF.request(url, method: .delete).response { response in
			if let statusCode = response.response?.statusCode {
				switch statusCode {
				case 200..<300:
					if let data = response.data {
						do {
							let root = try JSONDecoder().decode(APIError.self, from: data)
							self.showAlert = true
							self.message = root.message
							
							UserDefaults.standard.removeObject(forKey: "homeId")
							UserDefaults.standard.removeObject(forKey: "homeName")
						} catch {
							log("decoding error")
						}
					}
				default :
					self.showAlert = true
					self.message = "집 삭제 실패"
				}
			}
		}
	}
}
