//
//  DateFormatter.swift
//  MyRoomFE
//
//  Created by jhshin on 11/22/24.
//

import Foundation

func stringToDate(_ dateString: String?) -> Date {
	let formatter = DateFormatter()
	formatter.dateFormat = "yyyy-MM-dd" // 저장된 날짜 형식에 맞게 수정
	return formatter.date(from: dateString ?? "") ?? Date()
}
func dateToString(_ date: String?) -> String {
	let subString = String(describing: date?.split(separator: "T").first ?? "")
	return subString
}
