//
//  LogManager.swift
//  MyRoomFE
//
//  Created by jhshin on 11/26/24.
//

import Foundation

// LogTrait 열거형 정의
enum LogTrait: String {
	case app = "☄️"
	case verbose = "🔍"
	case debug = "💬"
	case success = "😌"
	case info = "ℹ️"
	case warning = "⚠️"
	case error = "🔥"
}

// 로그 함수 정의
func log(_ message: String,
				 trait: LogTrait = .info,
				 function: String = #function,
				 line: Int = #line,
				 file: String = #file) {
	let currentTime = Date()
	let formatter = DateFormatter()
	formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
	let timestamp = formatter.string(from: currentTime)
	
	let fileName = (file as NSString).lastPathComponent
	
	print("[\(timestamp)] [\(trait.rawValue)] \(message) (in \(fileName):\(line) - \(function))")
}
