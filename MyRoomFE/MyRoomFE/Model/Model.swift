//
//  Model.swift
//  MyRoomFE
//
//  Created by tmshini on 11/18/24.
//

import Foundation

//MARK: ITEM
struct Item: Codable,Identifiable, Equatable {
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
	let itemPhoto: [ItemPhoto]?
	let location: Item_Location?
}
struct ItemPhoto: Codable, Identifiable,Equatable {
	let id: Int
	let photo: String
}
struct Item_Location: Codable,Equatable {
	let locationName: String
	let room: Item_Room
}
struct Item_Room: Codable,Equatable {
	let roomName: String
}
struct ItemResponse: Codable {
	let documents: [Item]
}

//MARK: ROOM AND LOCATION
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

//MARK: POST
struct Post: Identifiable,Codable,Equatable {
	let id: Int
	let title: String
	let content: String
	let nickName: String
	let userImage:String
	let thumbnail: String
	let user: User
	let postFavCnt: Int
	let postViewCnt: Int
	let images: [PostPhotoData]
}

struct PostRoot: Codable{
	let success: Bool
	let posts: [Post]
	let message: String
}

struct PostPhotos: Codable,Equatable {
	let images: [UsedPhotoData]
}

struct PostPhotoData:Identifiable,Codable, Equatable, Hashable  {
	let id:Int
	let image:String
}

struct Comment: Identifiable ,Codable{
	var id:Int
	var comment: String
	var userImage:String
	var nickName:String
	var date:String
}

//MARK: USER
struct User : Codable,Equatable {
	let id: Int
	let userName: String
	let nickname:String
	let userImage:String?
	let mateId: Int?
	let createdAt: String
	let updatedAt: String
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

//MARK: USED
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

struct UsedRoot: Codable{
	//    let success: Bool
	let useds: [Used]
	//    let message: String
}

struct UsedPhotos: Codable,Equatable {
	let images: [UsedPhotoData]
}

struct UsedPhotoData:Identifiable,Codable, Equatable, Hashable  {
	let id:Int
	let image:String
}

struct UsedFavs:Codable,Equatable {
	let usedFav: [UsedFavData]
}

struct UsedFavData:Identifiable,Codable, Equatable {
	let id:Int
	let usedId:Int
	let userId:Int
}

struct ApiResponse: Error, Decodable {
	let success: String?
	let message: String
}
