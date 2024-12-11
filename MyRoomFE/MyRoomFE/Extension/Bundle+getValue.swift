//
//  Bundle+getValue.swift
//  MyRoomFE
//
//  Created by jhshin on 12/10/24.
//

import Foundation

extension Bundle {
		/// Info.plist에서 설정 값을 안전하게 가져오는 메서드
		/// - Parameter key: Info.plist의 Key 이름
		/// - Returns: Optional String 값
		func value(for key: String) -> String? {
				return object(forInfoDictionaryKey: key) as? String
		}
		
		/// 필수 키의 값을 가져올 때 사용하는 메서드 (값이 없으면 크래시 발생)
		/// - Parameter key: 필수 Key 이름
		/// - Returns: Key에 해당하는 String 값
		func requiredValue(for key: String) -> String {
				guard let value = object(forInfoDictionaryKey: key) as? String else {
						fatalError("Missing required Info.plist key: \(key)")
				}
				return value
		}
}
