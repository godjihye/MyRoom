////
////  ImagePicker.swift
////  MyRoomFE
////
////  Created by jhshin on 11/20/24.
////
//
//
//import SwiftUI
//import PhotosUI
//
//class ImagePickerCoordinator:NSObject, PHPickerViewControllerDelegate {
//	let parent:ImagePicker
//	
//	init(parent: ImagePicker) {
//		self.parent = parent
//	}
//	
//	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//		guard let itemProvider = results.first?.itemProvider
//		else {return}
//		if itemProvider.canLoadObject(ofClass: UIImage.self){
//			itemProvider.loadObject(ofClass: UIImage.self) { image, error in
//				self.parent.image = image as? UIImage
//			}
//		}
//		picker.dismiss(animated: true)
//	}
//}
//
//
//struct ImagePicker: UIViewControllerRepresentable {
//	@Binding var image:UIImage?
//	func makeUIViewController(context: Context) -> PHPickerViewController {
//		var config = PHPickerConfiguration()
//		config.filter = .images
//		config.selectionLimit = 1
//		let picker = PHPickerViewController(configuration: config)
//		return picker
//	}
//	
//	func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
//		uiViewController.delegate = context.coordinator
//	}
//	
//	func makeCoordinator() -> ImagePickerCoordinator {
//		ImagePickerCoordinator(parent: self)
//	}
//}
//
//struct ImagePickerView:View {
//	@State var isPresented: Bool = false
//	@State var aImage: UIImage?
//	var body: some View {
//		VStack {
//			if let aImage{
//				Image(uiImage:aImage).resizable().frame(width: 300, height: 300)
//			}
//			Button {
//				isPresented.toggle()
//			} label: {
//				ImgUploadRectBtn()
//			}.sheet(isPresented: $isPresented) {
//				ImagePicker(image: $aImage)
//				
//			}
//		}
//	}
//}
//
//
//#Preview {
//	ImagePickerView()
//}
//
//
