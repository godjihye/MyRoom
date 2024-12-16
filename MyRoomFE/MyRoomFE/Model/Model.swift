//
//  Model.swift
//  MyRoomFE
//
//  Created by tmshini on 11/18/24.
//

import Foundation

//MARK: - ITEM(물건)

struct Item: Codable, Identifiable, Equatable {
	var id: Int
	var itemName: String
	var purchaseDate: String?
	var expiryDate: String?
	var url: String?
	var photo: String?
	var desc: String?
	var color: String?
	var isFav: Bool
	var price: Int?
	var openDate: String?
	var locationId: Int
	var createdAt: String
	var updatedAt: String
	var itemPhoto: [ItemPhoto]?
	var location: Item_Location?
	static func == (lhs: Item, rhs: Item) -> Bool {
		return lhs.id == rhs.id
	}
}

struct ItemPhoto: Codable, Identifiable, Equatable {
	let id: Int
	let photo: String
	let photoText: String?
	let photoTextAI: String?
}

struct Item_Location: Codable, Equatable {
    let locationName: String
    let room: Item_Room
}

struct Item_Room: Codable, Equatable {
    let roomName: String
}

struct ItemResponse: Codable {
    let documents: [Item]
}

struct ItemRoot: Codable {
    let success: Bool
    let message: String
    let item: Item
}

struct AdditionalPhoto: Decodable {
    let photo: String
    let itemId: Int
}

struct AdditionalPhotosRoot: Decodable {
    let success: Bool
    let message: String
    let photos: AdditionalPhoto
}

struct DeleteAdditionalPhotosRoot: Decodable {
	let success: Bool
	let message: String
	let itemId: Int
	let id: Int
}

//MARK: - ROOM AND LOCATION (방/위치)

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
    let homeId: Int
    let createdAt: String
    let updatedAt: String
    let locations: [Location]
}

struct RoomResponse:Codable {
    let documents: [Room]
}


//MARK: - POST(커뮤니티 게시글)
struct PostUser: Codable,Equatable {
    let id:Int
    let nickname: String
    let userImage: String?
}
struct Post: Identifiable,Codable,Equatable {
	let id: Int
	let postTitle: String
	let postContent: String
	let postThumbnail: String
	
	let user: PostUser
	
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
	let btnData:[ButtonData]?
}

struct ButtonData: Identifiable, Codable, Equatable, Hashable {
	let id: Int
	let positionX: CGFloat
	let positionY: CGFloat
	let itemUrl: String
}

struct PostFavData:Identifiable,Codable, Equatable {
    let id:Int
    let postId:Int
    let userId:Int
}

//MARK: - COMMENT(댓글)

struct Comment: Identifiable, Codable{
	let id:Int
	let comment: String
	let user:CommentUser
	var replies: [Comment]?
	let updatedAt:String
}

struct CommentRoot: Codable {
	let comments: [Comment]
}

struct CommentUser : Codable {
	let nickname: String
	let userImage: String?
}

//MARK: - HOME(집)

struct Home: Codable, Equatable {
    let id: Int
    let homeName: String
    let homeDesc: String?
    let updatedAt: String
    let createdAt: String
    let inviteCode: String
}

struct HomeRoot: Codable {
    let message: String
    let success: Bool
    let home: Home
}

struct InviteCode: Codable {
    let inviteCode: String
}

struct InviteCodeRoot: Codable {
    let inviteCode: InviteCode
}

//MARK: - USER(사용자)

struct User : Codable, Equatable {
	let id: Int
	let userName: String
	var nickname: String
	var userImage: String?
	let createdAt: String
	let updatedAt: String
	var homeId: Int?
	var mates: [MateUser]?
	var homeUser: Home?
}

struct MateUser: Codable, Equatable, Identifiable {
    let id: Int
    let userImage: String?
    let nickname: String
}

struct UserInfo: Codable {
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

struct ImageUpload: Codable {
    let imageUrl: String
}

//MARK: -Used

struct Used: Identifiable,Codable,Equatable {
    let id: Int
    let usedTitle: String
    let usedPrice: Int
    let usedDesc: String
    let user: User
    let usedUrl: String?
    var usedStatus: Int
    let usedPurchaseDate: String?
    let usedExpiryDate: String?
    let usedOpenDate: String?
    let purchasePrice: Int?
    let itemName:String?
    let itemDesc:String?
    let usedFavCnt: Int
    let usedViewCnt: Int
    let usedChatCnt: Int
    let images: [UsedPhotoData]
    let usedThumbnail: String
    var isFavorite:Bool
    let usedFav: [UsedFavData]?
    let updatedAt: String
        
    let item:Item?
    
    mutating func toggleFavorite() {
        isFavorite.toggle()
    }
    mutating func setFavorite(_ value: Bool) {
        isFavorite = value
    }
        
        
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

struct UsedRoot: Codable{
	let success: Bool
	let useds: [Used]
	let message: String
}


//MARK: - Chat
struct Message: Identifiable {
	let id: String
	let senderId: String
	let text: String
	let timestamp: Double
}

struct ChatRoom: Identifiable {
	var id: String
	var roomName: String
	var participants: [String]
	var imageUrls: [String: String]
}



//MARK: - API Response

struct ApiResponse: Error, Decodable {
    let success: Bool
    let message: String
}

struct APIError: Codable {
    let message: String
}
