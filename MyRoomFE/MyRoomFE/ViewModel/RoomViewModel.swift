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
								let allLocations = root.documents.flatMap { $0.Locations }
								self.locations = allLocations
							} catch {
								print("error: \(error)")
							}
						}
					default:
						print("network error")
					}
				}
			}
	}
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
	func removeRoom(roomId: Int) {
		let url = "\(endPoint)/rooms/\(roomId)"
		AF.request(url, method: .delete)
			.response { response in
				if let statusCode = response.response?.statusCode {
					switch statusCode {
					case 200..<300:
						print("removeRoom 성공")
					default:
						print("실패")
					}
				}
			}
	}
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
