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
	let userId = 3
	let endPoint = Bundle.main.object(forInfoDictionaryKey: "ENDPOINT") as! String
	
	// CRUD

	// 1. Create
	/// 1-1) Create Room
	func addRoom(roomName: String, roomDesc: String) {
		let url = "\(endPoint)/rooms"
		let params: [String: Any] = [
			"roomName": roomName,
			"roomDesc": roomDesc,
			"userId": userId
		]
		AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
			.response { response in
				switch response.result {
				case .success(_):
					print("success!")
				case .failure(let error):
					print("Error: \(error)")
				}
			}
	}
	/// 1-2) Create Location
	func addLocation(locationName: String, locationDesc: String, roomId: Int) {
		let url = "\(endPoint)/locations"
		let params: [String: Any] = [
			"locationName": locationName,
			"locationDesc": locationDesc,
			"roomId": roomId
		]
		AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
			.response { response in
				switch response.result {
				case .success(_):
					print("success!")
				case .failure(let error):
					print("Error: \(error)")
				}
			}
	}
	// 2. Read
	/// 2. Read Rooms/Locations
	func fetchRooms() {
		let url = "\(endPoint)/rooms/list/\(userId)"
		AF.request(url, method: .get)
			.response { response in
				if let statusCode = response.response?.statusCode {
					switch statusCode {
					case 200..<300:
						if let data = response.data {
							do {
								let root = try JSONDecoder().decode(RoomResponse.self, from: data)
								self.rooms = root.documents
								let allLocations = root.documents.flatMap { room in
										room.Locations.map { location in
												var updatedLocation = location
												updatedLocation.roomId = room.id
												return updatedLocation
										}
								}
								self.locations = allLocations
							} catch {
								print("fetchRooms error: \(error)")
							}
						}
					default:
						print("fetchRooms: network error")
					}
				}
			}
	}
	// 3. Update
	/// 3-1) Update Room
	func editRoom(roomId: Int, roomName: String, roomDesc: String) {
		print("editRoom")
		let url = "\(endPoint)/rooms/\(roomId)"
		let params: Parameters = [
			"roomName": roomName,
			"roomDesc": roomDesc,
		]
		AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default)
			.response { response in
				if let statusCode = response.response?.statusCode {
					switch statusCode {
					case 200..<300:
						print("editRoom 성공")
					default:
						print("editRoom 실패")
					}
				}
			}
	}
	/// 3-2) Update Location
	func editLocation(locationId: Int, locationName: String, locationDesc: String, roomId: Int) {
		let url = "\(endPoint)/locations/\(locationId)"
		let params: Parameters = [
			"locationName": locationName,
			"locationDesc": locationDesc,
			"roomId": roomId
		]
		AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default)
			.response { response in
				if let statusCode = response.response?.statusCode {
					switch statusCode {
					case 200..<300:
						print("editLocation 성공")
					default:
						print("실패")
					}
				}
			}
	}
	// 4. Delete
	/// 4-1) Delete Room
	func removeRoom(roomId: Int) {
		let url = "\(endPoint)/rooms/\(roomId)"
		AF.request(url, method: .delete)
			.response { response in
				if let statusCode = response.response?.statusCode {
					switch statusCode {
					case 200..<300:
						print("removeRoom 성공")
					default :
						print("removeRoom 실패")
					}
				}
			}
	}
	/// 4-2) Delete Location
	func removeLocation(locationId: Int) {
		let url = "\(endPoint)/locations/\(locationId)"
		AF.request(url, method: .delete)
			.response { response in
				if let statusCode = response.response?.statusCode {
					switch statusCode {
					case 200..<300:
						print("removeLocation 성공")
					default:
						print("실패")
					}
				}
			}
	}
}

