//
//  MultipartFormData+AppendOptionalValue.swift
//  MyRoomFE
//
//  Created by jhshin on 12/8/24.
//

import Foundation
import Alamofire

func addFormData<T>(formData: MultipartFormData, optionalValue: T?, withName: String) {
	guard let value = optionalValue else { return }
	
	var data: Data?
	
	// 타입에 따라 데이터 변환 처리
	if let stringValue = value as? String {
		data = stringValue.data(using: .utf8)
	} else if let dateValue = value as? Date {
		// Date는 ISO8601 형식으로 문자열로 변환
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // 예: "2024-12-08T14:25:30Z"
		let dateString = formatter.string(from: dateValue)
		data = dateString.data(using: .utf8)
	} else if let intValue = value as? Int {
		// Integer는 문자열로 변환
		let intString = String(intValue)
		data = intString.data(using: .utf8)
	} else {
		return
	}
	
	if let data = data {
		formData.append(data, withName: withName)
	}
}
