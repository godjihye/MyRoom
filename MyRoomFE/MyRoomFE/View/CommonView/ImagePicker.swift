//
//  PhotoPickerView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//

import SwiftUI
import PhotosUI


class ImagePickerCoordinator:NSObject, PHPickerViewControllerDelegate {
	let parent:ImagePicker
	init(parent: ImagePicker) {
		self.parent = parent
	}
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		guard let itemProvider = results.first?.itemProvider
		else {return}
		if itemProvider.canLoadObject(ofClass: UIImage.self){
			itemProvider.loadObject(ofClass: UIImage.self) { image, error in
				self.parent.image = image as? UIImage
			}
		}
		picker.dismiss(animated: true)
	}
}

struct ImagePicker: UIViewControllerRepresentable {
	@Binding var image:UIImage?
	var selectionLimit = 1
	func makeUIViewController(context: Context) -> PHPickerViewController {
		var config = PHPickerConfiguration()
		config.filter = .images
		config.selectionLimit = selectionLimit
		let picker = PHPickerViewController(configuration: config)
		return picker
	}
	
	func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
		uiViewController.delegate = context.coordinator
	}
	
	func makeCoordinator() -> ImagePickerCoordinator {
		ImagePickerCoordinator(parent: self)
	}
}


