//
//  ImagePicker.swift
//  MyRoomFE
//
//  Created by jhshin on 11/25/24.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
	@Binding var selectedImages: [UIImage]
	var selectionLimit: Int
	
	func makeUIViewController(context: Context) -> PHPickerViewController {
		var config = PHPickerConfiguration()
		config.filter = .images
		config.selectionLimit = selectionLimit
		
		let picker = PHPickerViewController(configuration: config)
		picker.delegate = context.coordinator
		return picker
	}
	
	func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(self)
	}
	
	class Coordinator: NSObject, PHPickerViewControllerDelegate {
		let parent: ImagePicker
		
		init(_ parent: ImagePicker) {
			self.parent = parent
		}
		
		func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
			picker.dismiss(animated: true)
			var selected: [UIImage] = []
			for result in results {
				if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
					result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
						if let image = object as? UIImage {
							selected.append(image)
						}
					}
				}
			}
			DispatchQueue.main.async {
				self.parent.selectedImages = selected
			}
		}
	}
}



