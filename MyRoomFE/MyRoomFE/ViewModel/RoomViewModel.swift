//
//  RoomViewModel.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import Foundation
import Alamofire
import SwiftUICore

class RoomViewModel: ObservableObject {
	@Published var rooms: [Room] = []
	@Published var locations: [Location] = []
	let userId = 1
	let endPoint = Bundle.main.object(forInfoDictionaryKey: "ENDPOINT") as! String
	
	// CRUD
	
	// 1. Create
	/// 1-1) Create Room
	func addRoom(roomName: String, roomDesc: String) async {
		let url = "\(endPoint)/rooms"
		let params: [String: Any] = ["roomName": roomName, "roomDesc": roomDesc, "userId": userId]
		do {
			let response = try await AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).serializingDecodable(RoomResponse.self).value
			self.rooms = response.documents
			print("addRoom() Complete")
		} catch {
			if let afError = error as? AFError {
				print("AF Error! \(afError)")
			} else {
				print("Unexpected Error: \(error)")
			}
		}
	}
	/// 1-2) Create Location
	func addLocation(locationName: String, locationDesc: String, roomId: Int) async {
		let url = "\(endPoint)/locations"
		let params: [String: Any] = ["locationName": locationName, "locationDesc": locationDesc, "roomId": roomId]
		do {
			let response = try await AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).serializingData().value
			print("addLocation Complete")
		} catch {
			print("Error: \(error)")
		}
	}
	
	// 2. Read
	/// 2. Read Rooms/Locations
	func fetchRooms() async {
		let url = "\(endPoint)/rooms/list/\(userId)"
		do {
			let response = try await AF.request(url, method: .get).serializingDecodable(RoomResponse.self).value
			DispatchQueue.main.async {
				self.rooms = response.documents;
				self.locations = response.documents.flatMap { $0.Locations }
			}
		} catch {
			if let afError = error as? AFError {
				print("afError: \(afError)")
			} else {
				print("Unexpected Error: \(error)")
			}
		}
	}
	// 3. Update
	/// 3-1) Update Room
	func editRoom(roomId: Int, roomName: String, roomDesc: String) async {
		let url = "\(endPoint)/rooms/\(roomId)"
		let params: Parameters = [
			"roomName": roomName,
			"roomDesc": roomDesc,
		]
		do {
			let response = try await AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default).serializingData().value
			print("editRoom Complete")
		} catch {
			print("editRoom Error: \(error)")
		}
	}
	/// 3-2) Update Location
	func editLocation(locationId: Int, locationName: String, locationDesc: String, roomId: Int) async {
		let url = "\(endPoint)/locations/\(locationId)"
		let params: Parameters = ["locationName": locationName, "locationDesc": locationDesc, "roomId": roomId]
		do {
			let response = try await AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default).serializingData().value
			print("editLocation")
		} catch {
			print("editLocation Error: \(error)")
		}
	}
	// 4. Delete
	/// 4-1) Delete Room
	func removeRoom(roomId: Int) async {
		let url = "\(endPoint)/rooms/\(roomId)"
		do {
			let response = try await AF.request(url, method: .delete).serializingData().value
			print("removeRoom Complete")
		} catch {
			print("removeRoom Failure")
		}
	}
	/// 4-2) Delete Location
	func removeLocation(locationId: Int) async {
		let url = "\(endPoint)/locations/\(locationId)"
		do {
			let response = try await AF.request(url, method: .delete).serializingData().value
			print("removeLocation Complete")
		} catch {
			print("removeLocation Error: \(error)")
		}
	}
}

