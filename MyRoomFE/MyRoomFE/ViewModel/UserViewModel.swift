//
//  UserViewModel.swift
//  MyRoomFE
//
//  Created by jhshin on 11/19/24.
//

import Foundation
import Alamofire

class UserViewModel: ObservableObject {
	@Published var isLoggedIn = false
	@Published var isLoginError = false
	@Published var message: String = ""
	@Published var isJoinShowing = false
	
}
