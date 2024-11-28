//
//  Comment.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//



import Foundation

struct Comments: Identifiable ,Codable{
    var id:Int
    var comment: String
    var userImage:String
    var nickName:String
    var date:String
}

