//
//  DateFormatter.swift
//  MyRoomFE
//
//  Created by jhshin on 11/22/24.
//
//
//  DateFormatter.swift
//  MyRoomFE
//
//  Created by jhshin on 11/22/24.
//

import Foundation

extension String {
	
	func stringToDate() -> Date {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter.date(from: self) ?? Date()
	}
	
	func dateToString() -> String {
		let isoFormatter = ISO8601DateFormatter()
		isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
		let justDateFormatter = DateFormatter()
		justDateFormatter.dateFormat = "yyyy-MM-dd"
		justDateFormatter.timeZone = .current
		guard let date = isoFormatter.date(from: self) else {
			print("Invalid ISO8601 date format")
			return ""
		}
		let justDate = justDateFormatter.string(from: date)
		return justDate
	}
	
	func datesSince() -> Int? {
		let targetDate = self.dateToString().stringToDate()
		let currentDate = Date()
		let calendar = Calendar.current
		let components = calendar.dateComponents([.day], from: targetDate, to: currentDate)
		return components.day
	}
}
