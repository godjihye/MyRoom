//
//  Used.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//


import Foundation

struct Useds: Identifiable,Codable,Equatable {
    
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
    let useds: [Useds]
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


