//
//  UserViewMode.swift
//  MyRoomFE
//
//  Created by jhshin on 12/1/24.
//

import Foundation

struct User : Codable,Equatable {
	let userName: String
	let nickName: String
	let userImage:String?
}

struct SignUp: Codable {
	let success: Bool
	let user: User
	let message: String
}

struct SignIn: Codable {
	let success: Bool
	let token: String
	let user: User
	let message: String
}
