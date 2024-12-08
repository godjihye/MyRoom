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
		formatter.dateFormat = "yyyy-MM-dd" // 저장된 날짜 형식에 맞게 수정
		return formatter.date(from: self) ?? Date()
	}
	
	func dateToString() -> String {
		let subString = String(describing: self.split(separator: "T").first ?? "")
		return subString
	}
	
	func datesSince() -> Int? {
		let targetDate = self.dateToString().stringToDate()
		let currentDate = Date()
		let calendar = Calendar.current
		let components = calendar.dateComponents([.day], from: targetDate, to: currentDate)
		return components.day
	}
}
