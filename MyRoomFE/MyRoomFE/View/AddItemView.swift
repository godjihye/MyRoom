//
//  AddItemView.swift
//  MyRoomFE
//
//  Created by jhshin on 11/19/24.
//

//import SwiftUI
//
//struct AddItemView: View {
//	@EnvironmentObject var itemVM: ItemViewModel
//	@State var itemName: String = ""
//	@State var itemDesc: String = ""
//	@State var itemLocation: String = ""
//	@State var itemPrice: String = ""
//	@State var itemUrl: String = ""
//	@State var purchaseDate: Date = Date()
//	@State var expiryDate: Date = Date()
//	@State var openDate: Date = Date()
//	@Environment(\.dismiss) private var dismiss
//
//    var body: some View {
//			HStack {
//				VStack(alignment: .leading, spacing: 40) {
//					VStack(alignment: .leading) {
//						Text("• 사진 업로드")
//							.bold()
//						ImagePickerView()
//					}
//					VStack(alignment: .leading){
//						Text("• 기본 정보")
//							.bold()
//						VStack(alignment: .leading) {
//							Text("상품명")
//								.bold()
//							VStack(alignment: .leading, spacing: 0) {
//								HStack {
//									Text("AI 추천: ")
//								}
//								HStack {
//									Text("직접 입력하기: ")
//									Spacer()
//									AddItemTextField(width: 200, text: $itemName)
//								}
//							}
//							.padding(.leading)
//
//							VStack(alignment: .leading, spacing: 0) {
//								Text("위치")
//									.bold()
//								//AddItemTextField(width: 100)
//							}
//							VStack(alignment: .leading, spacing: 5) {
//								Text("상품 설명")
//									.bold()
//								AddItemTextField(width: 200, text: $itemDesc)
//							}
//						}
//						.padding(.horizontal)
//					}
//					VStack(alignment: .leading) {
//						Text("• 부가 정보")
//							.bold()
//						VStack(alignment: .leading, spacing: 5) {
//							HStack {
//								Text("가격")
//								Spacer()
//								AddItemTextField(width: 200, text: $itemPrice)
//								//AddItemTextField(width: 200)
//							}
//
//							HStack {
//								Text("구매 URL")
//								Spacer()
//								AddItemTextField(width: 200, text: $itemUrl)
//								//AddItemTextField(width: 200)
//							}
//							HStack {
//								Text("구매일자")
//								Spacer()
//								AddItemDatePicker()
//								//AddItemTextField(width: 200)
//							}
//							HStack {
//								Text("유통기한")
//								Spacer()
//								AddItemDatePicker()
//								//AddItemTextField(width: 200)
//							}
//							HStack {
//								Text("개봉일자")
//								Spacer()
//								AddItemDatePicker()
//								//AddItemTextField(width: 200)
//							}
//						}
//						.padding(.horizontal)
//					}
//				}
//				Spacer()
//
//			}
//			.onSubmit {
//				//itemVM.addItem()
//			}
//			.toolbar(content: {
//				ToolbarItem(placement: .topBarTrailing) {
//					Button {
//
//					} label: {
//						Image(systemName: "Save")
//					}
//
//				}
//			})
//			.padding()
//			.frame(maxWidth: .infinity, maxHeight: .infinity)
//			.background(Color.backgroud)
//
//    }
//}
//
//#Preview {
//    AddItemView()
//}

import SwiftUI
import PhotosUI

struct AddItemView: View {
	@State private var itemName: String = ""
	@State private var itemDesc: String = ""
	@State private var itemLocation: String = ""
	@State private var itemPrice: String = ""
	@State private var itemUrl: String = ""
	@State private var purchaseDate: Date = Date()
	@State private var expiryDate: Date = Date()
	@State private var openDate: Date = Date()
	@State private var selectedImage: UIImage? = nil
	@State private var isImagePickerPresented: Bool = false
	@State private var selectedLocationId: Int = 0
	@State private var itemColor: String = ""
	let locations: [Location]
	@EnvironmentObject var itemVM: ItemViewModel
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		NavigationStack {
			Form {
				Section(header: Text("Image")) {
					if let image = selectedImage {
						Image(uiImage: image)
							.resizable()
							.scaledToFit()
							.frame(height: 200)
							.cornerRadius(10)
					} else {
						Text("No image selected")
							.foregroundColor(.gray)
					}
					
					Button("이미지 선택 / 변경") {
						isImagePickerPresented = true
					}
				}
				Section(header: Text("기본 정보")) {
					TextField("아이템 이름", text: $itemName)
					TextField("아이템 설명", text: $itemDesc)
					Picker("아이템 위치", selection: $selectedLocationId) {
						ForEach(locations) { location in
							Text(location.locationName).tag(location as Location?)
						}
						.pickerStyle(MenuPickerStyle())
					}
					TextField("Price", text: $itemPrice)
						.keyboardType(.decimalPad)
					TextField("URL", text: $itemUrl)
						.keyboardType(.URL)
				}
				Section(header: Text("추가 정보")) {
					DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: .date)
					DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)
					DatePicker("Open Date", selection: $openDate, displayedComponents: .date)
				}
			}
			.navigationTitle("새로운 아이템 추가")
			
			.toolbar (
content: {
				ToolbarItem(placement: .confirmationAction) {
					Button("Save") {
						itemVM
							.addItem(
								itemName: itemName,
								purchaseDate: purchaseDate.description,
								expiryDate: expiryDate.description,
								itemUrl: itemUrl,
								image: selectedImage,
								desc: itemDesc,
								color: itemColor,
								price: Int(itemPrice),
								openDate: openDate.description,
								locationId: selectedLocationId
							)
						itemVM.fetchItems(locationId: selectedLocationId)
						dismiss()
					}
					.disabled(itemName.isEmpty || selectedImage == nil)
				}
				ToolbarItem(placement: .cancellationAction) {
					Button("Cancel") {
						dismiss()
					}
				}
			})
		}
		.sheet(isPresented: $isImagePickerPresented) {
			ImagePicker(selectedImage: $selectedImage)
		}
	}
}

// ImagePicker Component
struct ImagePicker: UIViewControllerRepresentable {
	@Binding var selectedImage: UIImage?
	
	func makeUIViewController(context: Context) -> PHPickerViewController {
		var config = PHPickerConfiguration()
		config.filter = .images
		config.selectionLimit = 1
		
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
			
			if let result = results.first, result.itemProvider.canLoadObject(ofClass: UIImage.self) {
				result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
					if let image = object as? UIImage {
						DispatchQueue.main.async {
							self.parent.selectedImage = image
						}
					}
				}
			}
		}
	}
}


//#Preview {
//	let locations: [Location] = [Location(id: 1, locationName: "공부방", locationDesc: "공부방이에요")]
//	
//	AddItemView(locations: locations) { _ in
//	}
//}
