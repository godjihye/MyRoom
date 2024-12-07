//
//  String+AzureStorageURL.swift
//  MyRoomFE
//
//  Created by jhshin on 12/3/24.
//

import Foundation

private let azureStoragePrefix = Bundle.main.object(forInfoDictionaryKey: "AZURESTORAGE") as! String

extension String {
	func addingURLPrefix() -> String {
		if self.hasPrefix("http://") || self.hasPrefix("https://") {
			return self
		}
		return "\(azureStoragePrefix)\(self)"
	}
}
