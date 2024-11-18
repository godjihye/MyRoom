//
//  RoomViewModel.swift
//  MyRoomFE
//
//  Created by jhshin on 11/18/24.
//

import Foundation
import Alamofire

class RoomViewModel: ObservableObject {
	@Published var rooms: [Room] = []
	
	let userId = 3
	let endPoint = Bundle.main.object(forInfoDictionaryKey: "ENDPOINT") as! String
	
	func fetchRooms() async {
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
	func addRoom(roomName: String, roomDesc: String) async {
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
	func addLocation(locationName: String, locationDesc: String, roomId: Int) async {
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
}
