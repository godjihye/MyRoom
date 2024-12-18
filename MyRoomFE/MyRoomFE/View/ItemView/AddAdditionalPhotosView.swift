//
//  AddAdditionalPhotosView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/3/24.
//

import SwiftUI
import _PhotosUI_SwiftUI
import Vision

struct AddAdditionalPhotosView: View {
	@Environment(\.dismiss) private var dismiss
	@EnvironmentObject var itemVM: ItemViewModel
	@State private var isShowingImageSource = false
	@State private var isPhotosPickerPresented = false
	@State private var isCameraPresented = false
	@State private var additionalItems: [PhotosPickerItem] = []
	@State private var additionalPhotos: [UIImage] = []
	@State private var cameraPhoto: UIImage?
	@State private var imageText: [String] = []
	private let maxImageCount = 30
	let itemId: Int
	let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]
	
	var body: some View {
		VStack {
			selectedImagesView
			selectImageBtnView
			Spacer()
			saveBtn
		}
		.navigationTitle("추가 이미지 등록")
		//				.toolbar {
		//						ToolbarItem(placement: .principal) {
		//								Text("추가 이미지 등록")
		//						}
		//				}
		// FIXME: - Text recognize
		.onChange(of: additionalItems) { _, _ in
			handleAdditionalItemsChange()
		}
		.onChange(of: cameraPhoto) { _, newValue in
			if let photo = newValue {
				additionalPhotos.append(photo)
				if let text = recognizeText(from: photo) {
					imageText.append(text)
				} else {
					imageText.append("")
				}
			}
		}
		.alert("추가 이미지 등록", isPresented: $itemVM.isShowingAlertAddAdditionalPhotos) {
			Button("확인", role: .cancel) {
				dismiss() 
			}
		} message: {
			Text(itemVM.addAdditionalPhotosMessage)
		}
		.fullScreenCover(isPresented: $isCameraPresented) {
			CameraPicker(image: $cameraPhoto, sourceType: .camera)
		}
		.photosPicker(
			isPresented: $isPhotosPickerPresented,
			selection: $additionalItems,
			maxSelectionCount: maxImageCount,
			matching: .images
		)
	}
	
	// MARK: - Subviews
	private var selectedImagesView: some View {
		GeometryReader { reader in
			ScrollView {
				LazyVGrid(columns: columns, spacing: 10) {
					ForEach(additionalPhotos, id: \.self) { photo in
						Image(uiImage: photo)
							.resizable()
							.scaledToFill()
							.frame(width: reader.size.width / 2 - 20, height: reader.size.width / 2 - 20)
							.cornerRadius(10)
					}
				}
				.padding()
			}
		}
	}
	
	private var selectImageBtnView: some View {
		Button {
			isShowingImageSource = true
		} label: {
			Text("추가 이미지 선택")
		}
		.buttonStyle(.bordered)
		.confirmationDialog("사진 소스 선택", isPresented: $isShowingImageSource) {
			Button("포토 앨범") {
				isPhotosPickerPresented = true
			}
			Button("카메라") {
				isCameraPresented = true
			}
		}
	}
	
	private var saveBtn: some View {
		Button(action: {
			//FIXME: - itemVM addAdditionalPhotos
			itemVM.addAdditionalPhotos(images: additionalPhotos, texts: imageText, itemId: itemId)
			log("imageText: \(imageText)")
			
		}) {
			Text("추가 이미지 등록")
				.frame(maxWidth: .infinity)
				.padding()
				.background(Color.accentColor)
				.foregroundColor(.white)
				.cornerRadius(10)
		}
		.padding()
	}
	
	// MARK: - Functions
	private func handleAdditionalItemsChange() {
		Task {
			for item in additionalItems {
				if let data = try? await item.loadTransferable(type: Data.self),
					 let uiImage = UIImage(data: data) {
					additionalPhotos.append(uiImage)
					if let text = recognizeText(from: uiImage) {
						imageText.append(text)
					} else {
						imageText.append("")
					}
				}
			}
		}
	}
	private func recognizeText(from image: UIImage) -> String? {
		var recognizedText: String = ""
		guard let cgImage = image.cgImage else {
			recognizedText.append("Could not load image.")
			return ""
		}
		
		let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
		let request = VNRecognizeTextRequest { request, error in
			guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
				recognizedText.append("Text recognition failed.")
				return
			}
			
			let text = observations.compactMap {
				$0.topCandidates(1).first?.string
			}
			
			recognizedText = text.joined(separator: " ")
			
		}
		
		if #available(iOS 16.0, *) {
			request.revision = VNRecognizeTextRequestRevision3
			request.recognitionLevel = .accurate
			request.recognitionLanguages = ["ko-KR"]
			request.usesLanguageCorrection = true
			
			do {
				let supportedLanguages = try request.supportedRecognitionLanguages()
//				print("Supported languages: \(supportedLanguages)")
			} catch {
//				print("Error fetching supported languages: \(error)")
			}
		} else {
			request.recognitionLanguages = ["en-US"]
			request.usesLanguageCorrection = true
		}
		do {
			try handler.perform([request])
		} catch {
			recognizedText.append("Error: \(error.localizedDescription)")
		}
		return recognizedText
	}
}

#Preview {
	let itemVM = ItemViewModel()
	AddAdditionalPhotosView(itemId: 1)
		.environmentObject(itemVM)
}
