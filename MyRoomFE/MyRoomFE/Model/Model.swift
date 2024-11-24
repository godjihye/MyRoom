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
		let locations: Item_Location
		enum CodingKeys: String, CodingKey {
				case id, itemName, purchaseDate, expiryDate, url, photo, desc, color, isFav, price, openDate, locationId, createdAt, updatedAt
				case itemPhotos = "ItemPhotos"
				case locations = "Locations"
		}
}
struct ItemPhoto: Codable, Identifiable {
		let id: Int
		let photo: String
}
struct Item_Location: Codable {
		let locationName: String
		let rooms: Item_Room

		enum CodingKeys: String, CodingKey {
				case locationName
				case rooms = "Rooms"
		}
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
	let Locations: [Location]
}

struct RoomResponse:Codable {
	let documents: [Room]
}
