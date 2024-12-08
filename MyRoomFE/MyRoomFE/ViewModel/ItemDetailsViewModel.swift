//
//  ItemDetailsViewModel.swift
//  MyRoomFE
//
//  Created by jhshin on 12/8/24.
//

import SwiftUI

struct ItemDetails {
	var itemName: String = ""
	var itemThumbnail: UIImage?
	var itemDesc: String = ""
	var itemPrice: String = ""
	var itemUrl: String = ""
	var purchaseDate: Date = Date()
	var expiryDate: Date = Date()
	var openDate: Date = Date()
	var selectedLocationId: Int = 0
	var itemColor: String = ""
}

import Foundation
import SwiftUI

class ItemDetailsViewModel: ObservableObject {
		@Published var itemName: String = ""
		@Published var itemThumbnail: UIImage? = nil
		@Published var itemDesc: String = ""
		@Published var itemPrice: String = ""
		@Published var itemUrl: String = ""
		@Published var purchaseDate: Date = Date()
		@Published var expiryDate: Date = Date()
		@Published var openDate: Date = Date()
		@Published var selectedLocationId: Int = 0
		@Published var itemColor: String = ""

		@Published var isItemThumbnailChanged: Bool = false
		
		var existingItem: Item? // 기존 아이템 정보
		var isEditMode: Bool
		
		init(existingItem: Item? = nil, isEditMode: Bool = false, locationId: Int = 0) {
				self.existingItem = existingItem
				self.isEditMode = isEditMode
				self.selectedLocationId = existingItem?.locationId ?? locationId
				
				if let item = existingItem {
						self.itemName = item.itemName
						self.itemDesc = item.desc ?? ""
						self.itemPrice = item.price.map { "\($0)" } ?? ""
						self.itemUrl = item.url ?? ""
						self.purchaseDate = item.purchaseDate?.stringToDate() ?? Date()
						self.expiryDate = item.expiryDate?.stringToDate() ?? Date()
						self.openDate = item.openDate?.stringToDate() ?? Date()
						self.itemColor = item.color ?? ""
				}
		}
		
		func saveItem(itemVM: ItemViewModel) {
				if isEditMode, let existingItem = existingItem {
						// 기존 아이템 수정
						itemVM.editItem(
								itemId: existingItem.id,
								itemName: hasValueChanged(itemName, existingItem.itemName) ? itemName : nil,
								purchaseDate: hasDateChanged(purchaseDate, existingItem.purchaseDate) ? purchaseDate.description : nil,
								expiryDate: hasDateChanged(expiryDate, existingItem.expiryDate) ? expiryDate.description : nil,
								itemUrl: hasValueChanged(itemUrl, existingItem.url ?? "") ? itemUrl : nil,
								image: isItemThumbnailChanged ? itemThumbnail : nil,
								desc: hasValueChanged(itemDesc, existingItem.desc) ? itemDesc : nil,
								color: hasValueChanged(itemColor, existingItem.color) ? itemColor : nil,
								price: hasValueChanged(Int(itemPrice), existingItem.price) ? Int(itemPrice) : nil,
								openDate: hasDateChanged(openDate, existingItem.openDate) ? openDate.description : nil,
								locationId: hasValueChanged(selectedLocationId, existingItem.locationId) ? selectedLocationId : nil
						)
				} else {
						// 새 아이템 추가
						itemVM.addItem(
								itemName: itemName,
								purchaseDate: purchaseDate.description,
								expiryDate: expiryDate.description,
								itemUrl: itemUrl,
								image: itemThumbnail,
								desc: itemDesc,
								color: itemColor,
								price: Int(itemPrice),
								openDate: openDate.description,
								locationId: selectedLocationId
						)
				}
		}

		var isSaveButtonDisabled: Bool {
				if let existingItem = existingItem {
						return !(
								hasValueChanged(itemName, existingItem.itemName) ||
								isItemThumbnailChanged ||
								hasValueChanged(itemDesc, existingItem.desc) ||
								hasValueChanged(Int(itemPrice), existingItem.price) ||
								hasValueChanged(itemUrl, existingItem.url ?? "") ||
								hasDateChanged(purchaseDate, existingItem.purchaseDate) ||
								hasDateChanged(expiryDate, existingItem.expiryDate) ||
								hasDateChanged(openDate, existingItem.openDate) ||
								hasValueChanged(selectedLocationId, existingItem.locationId) ||
								hasValueChanged(itemColor, existingItem.color)
						)
				}
				return itemName.isEmpty || selectedLocationId == 0
		}

		private func hasValueChanged<T: Equatable>(_ newValue: T, _ oldValue: T?) -> Bool {
				return newValue != oldValue
		}
		
		private func hasDateChanged(_ newDate: Date, _ oldDateString: String?) -> Bool {
				guard let oldDate = oldDateString?.stringToDate() else { return true }
				return !Calendar.current.isDate(newDate, equalTo: oldDate, toGranularity: .day)
		}
}
