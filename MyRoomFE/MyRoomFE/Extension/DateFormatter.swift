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

//func convertAndExtractDate(from isoDate: String) -> (fullDate: String, justDate: String)? {
//		// ISO8601 문자열에서 Date 객체로 변환하는 포맷터
//		let isoFormatter = ISO8601DateFormatter()
//		isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//
//		// 출력 포맷터: 로컬 타임존에 맞춘 날짜 포맷 (fullDate)
//		let fullDateFormatter = DateFormatter()
//		fullDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS Z"
//		fullDateFormatter.timeZone = .current
//
//		// 연-월-일만 추출하는 포맷터 (justDate)
//		let justDateFormatter = DateFormatter()
//		justDateFormatter.dateFormat = "yyyy-MM-dd"
//		justDateFormatter.timeZone = .current
//
//		// ISO8601 문자열을 Date 객체로 변환
//		guard let date = isoFormatter.date(from: isoDate) else {
//				print("Invalid ISO8601 date format")
//				return nil
//		}
//
//		// 변환된 Date를 원하는 형식으로 출력
//		let fullDate = fullDateFormatter.string(from: date)
//		let justDate = justDateFormatter.string(from: date)
//
//		return (fullDate, justDate)
//}

