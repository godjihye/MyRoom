//
//  Model.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import Foundation

struct Item: Identifiable, Codable, Hashable {
	let id: Int
	let itemName: String
	let purchaseDate: String?
	let expiryDate: String?
	let url: String?
	let photo: String?
	let desc: String?
	let color: String?
	var isFav: Bool
	let price: Int?
	let openDate: String?
	let locationId: Int
	let createdAt: String?
	let updatedAt: String?
	let locationName: String
	let roomName: String
	
	enum CodingKeys: String, CodingKey {
		case id, itemName, purchaseDate, expiryDate, url, photo, desc, color, isFav, price, openDate, locationId, createdAt, updatedAt
		case locationName = "Locations.locationName" // Mapping `location.locationName` to `locationName`
		case roomName = "Locations.Rooms.roomName" // Mapping `location.room.roomName` to `roomName`
	}
	mutating func changeIsFav() {
		isFav = !isFav
	}
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
	let Locations: [Location]
}

struct RoomResponse:Codable {
	let documents: [Room]
}
