//
//  Model.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import Foundation

struct Item: Codable,Identifiable {
		let id: Int
		let itemName: String
		let purchaseDate: String?
		let expiryDate: String?
		let url: String?
		let photo: String?
		let desc: String?
		let color: String?
		let isFav: Bool
		let price: Int?
		let openDate: String?
		let locationId: Int
		let createdAt: String
		let updatedAt: String
		let itemPhotos: [ItemPhoto]?
		let location: Item_Location
}
struct ItemPhoto: Codable, Identifiable {
		let id: Int
		let photo: String
}
struct Item_Location: Codable {
		let locationName: String
		let room: Item_Room
}
struct Item_Room: Codable {
	let roomName: String
}

struct ItemResponse: Codable {
	let documents: [Item]
}
struct Location: Identifiable, Codable, Hashable {
	let id: Int
	let locationName: String
	let locationDesc: String
	let roomId: Int
}
struct Room: Identifiable, Codable, Equatable, Hashable {
	static func == (lhs: Room, rhs: Room) -> Bool {
		return lhs.id == rhs.id
	}
	let id: Int
	let roomName: String
	let roomDesc: String
	let userId: Int
	let createdAt: String
	let updatedAt: String
	let locations: [Location]
}

struct RoomResponse:Codable {
	let documents: [Room]
}

//
//  Comment.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//

import Foundation

struct Comment: Identifiable ,Codable{
		var id:Int
		var comment: String
		var userImage:String
		var nickName:String
		var date:String
}

//
//  Post.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/17/24.
//

import Foundation

struct Post: Identifiable,Codable,Equatable {
    let id: Int
    let postTitle: String
    let postContent: String
    let postThumbnail: String
    
    let user: User
    
    let postFav: [PostFavData]?
    var isFavorite:Bool
    let postFavCnt: Int
    let postViewCnt: Int
    
    let updatedAt:String
    let createdAt:String
    
    let images: [PostPhotoData]
    
    mutating func toggleFavorite() {
        isFavorite.toggle()
    }
    
    mutating func setFavorite(_ value: Bool) {
        isFavorite = value
    }
}

struct PostRoot: Codable{
    let success: Bool
    let posts: [Post]
    let message: String
}

struct PostPhotoData:Identifiable,Codable, Equatable, Hashable  {
    let id:Int
    let image:String
}

struct PostFavData:Identifiable,Codable, Equatable {
    let id:Int
    let postId:Int
    let userId:Int
}

//
//  Used.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//


import Foundation

struct Used: Identifiable,Codable,Equatable {
    
    let id: Int
    let usedTitle: String
    let usedPrice: Int
    let usedDesc: String
    let user: User
    let usedUrl: String?
    let usedStatus: Int
    
    let usedPurchaseDate: String?
    let usedExpiryDate: String?
    let usedOpenDate: String?
    let purchasePrice: Int?
    
    let usedFavCnt: Int
    let usedViewCnt: Int
    let usedChatCnt: Int
    
    let images: [UsedPhotoData]
    let usedThumbnail: String
    var isFavorite:Bool
    let usedFav: [UsedFavData]?
    let updatedAt: String
    
    mutating func toggleFavorite() {
        isFavorite.toggle()
    }
    
    mutating func setFavorite(_ value: Bool) {
        isFavorite = value
    }
    
}

struct User : Codable,Equatable {
    let nickname:String
    let userImage:String?
}


struct UsedRoot: Codable{
    //    let success: Bool
    let useds: [Used]
    //    let message: String
}


struct UsedPhotoData:Identifiable,Codable, Equatable, Hashable  {
    let id:Int
    let image:String
}

struct UsedFavData:Identifiable,Codable, Equatable {
    let id:Int
    let usedId:Int
    let userId:Int
}


//채팅
struct Message: Identifiable {
    let id: String
    let senderId: String
    let text: String
    let timestamp: Double
}

struct ChatRoom: Identifiable {
    var id: String       // roomId
    var roomName: String     // 채팅방 이름
}



//
//  common.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/20/24.
//

import Foundation


struct APIError: Codable {
    let message: String
}
