//
//  CameraPicker.swift
//  MyRoomFE
//
//  Created by jhshin on 12/4/24.
//

import SwiftUI
import UIKit

class CameraPickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	let parent: CameraPicker
	
	init(parent: CameraPicker) {
		self.parent = parent
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let image = info[.originalImage] as? UIImage {
			parent.image = image
		}
		picker.dismiss(animated: true)
	}
}

struct CameraPicker: UIViewControllerRepresentable {
	@Binding var image: UIImage?
	var sourceType: UIImagePickerController.SourceType
	
	func makeUIViewController(context: Context) -> UIImagePickerController {
		let picker = UIImagePickerController()
		picker.sourceType = sourceType
		picker.delegate = context.coordinator
		picker.modalPresentationStyle = .fullScreen
		return picker
	}
	
	func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
	
	func makeCoordinator() -> CameraPickerCoordinator {
		CameraPickerCoordinator(parent: self)
	}
}

