//
//  Post.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/17/24.
//

import Foundation

struct Posts: Identifiable,Codable,Equatable {
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
    let posts: [Posts]
    let message: String
}



struct PostPhotos: Codable,Equatable {
    let images: [UsedPhotoData]
}


struct PostPhotoData:Identifiable,Codable, Equatable, Hashable  {
    let id:Int
    let image:String
}

