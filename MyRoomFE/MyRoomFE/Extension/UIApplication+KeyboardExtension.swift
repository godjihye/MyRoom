//
//  UIApplication+KeyboardExtension.swift
//  MyRoomFE
//
//  Created by jhshin on 11/28/24.
//

import Foundation
import SwiftUI

extension UIApplication {
		func hideKeyboard() {
			guard let windowScene = connectedScenes.first(where: { $0 is UIWindowScene }) as? UIWindowScene,
										let window = windowScene.windows.first else { return }
				let tapRecognizer = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
				tapRecognizer.cancelsTouchesInView = false
				tapRecognizer.delegate = self
				window.addGestureRecognizer(tapRecognizer)
		}
 }

extension UIApplication: @retroactive UIGestureRecognizerDelegate {
		public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
				return false
		}
}
