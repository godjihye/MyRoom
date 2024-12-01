//
//  Array+RawRepresentable.swift
//  MyRoomFE
//
//  Created by jhshin on 11/28/24.
//  @AppStorage를 배열로 쓰기 위함.

import Foundation

extension Array: @retroactive RawRepresentable where Element: Codable {
	public init?(rawValue: String) {
		guard let data = rawValue.data(using: .utf8),
					let result = try? JSONDecoder().decode([Element].self, from: data)
		else {
			return nil
		}
		self = result
	}
	
	public var rawValue: String {
		guard let data = try? JSONEncoder().encode(self),
					let result = String(data: data, encoding: .utf8)
		else {
			return "[]"
		}
		return result
	}
}
