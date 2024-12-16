//
//  UsedAddView.swift
//  MyRoomFE
//
//  Created by 이수정 on 11/18/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct UsedAddView: View {
	@EnvironmentObject var usedVM:UsedViewModel
	@Environment(\.dismiss) private var dismiss
	
	@FocusState private var titleIsFocused: Bool
	@FocusState private var contentIsFocused: Bool
	@State private var titleError: String? = nil
	@State private var contentError: String? = nil
	
	@State var isPickerPresented: Bool = false
	@State private var selectedItems: [PhotosPickerItem] = []
	@State private var selectedImages: [UIImage] = []
	private let maxImageCount = 10  //사진 개수
	@State private var showAlert = false
	@State private var message = ""
	
	@State var usedTitle : String
	@State var usedPrice : Int
	@State var usedContent : String
	
	//내 아이템 정보 가저오기
	@State private var isMyItemPresented: Bool = false
	@State private var selectMyItem: Item?
	
	@State var isCompleted : Bool = false
	
	let isEditMode: Bool
	let existingUsed: Used?
	
	init(
		isEditMode : Bool = false,
		existingUsed: Used? = nil
	){
		self.isEditMode = isEditMode
		self.existingUsed = existingUsed
		_usedTitle = State(initialValue: existingUsed?.usedTitle ?? "")
		_usedPrice = State(initialValue: existingUsed?.usedPrice ?? 0)
		_usedContent = State(initialValue: existingUsed?.usedDesc ?? "")
		_selectMyItem = State(initialValue: existingUsed?.item)
	}
	
	
	
	var body: some View {
		ScrollView {
			VStack {
				usedAddImageView
				
				VStack(alignment: .leading){
					myItemInfoSection
					usedTitleSection
					usedPriceSection
					usedDescSection
					addBtn
				}
			}
		}
		.padding(.bottom, 20)
		.padding(.top, 20)
	}
	
	private var addBtn:some View {
		
		WideButton(title: "작성완료", backgroundColor: .accent) {
			if usedTitle.isEmpty {
				titleError = "제목을 입력해주세요."
				titleIsFocused = true // 타이틀 필드로 포커스 이동
				return
			} else {
				titleError = nil
			}
			if usedContent.isEmpty {
				contentError = "내용을 입력해주세요."
				contentIsFocused = true // 콘텐츠 필드로 포커스 이동
				return
			} else {
				contentError = nil
			}
			if isEditMode {
				Task{
					// 편집 모드일 때 수정 로직
					await usedVM.updateUsed(
						usedId: existingUsed?.id ?? 0,
						newTitle: usedTitle,
						newPrice: usedPrice,
						newContent: usedContent,
						newItem: selectMyItem
					)
					
				}
			} else {
				// 새 아이템 등록 로직
				usedVM.addUsed(
					selectedImages: selectedImages,
					usedTitle: usedTitle,
					usedPrice: usedPrice,
					usedContent: usedContent,
					selectMyItem: selectMyItem
				)
				
			}
			
		}.alert("게시글 등록", isPresented: $usedVM.isAddShowing) {
			Button("확인") {
				usedVM.fetchUseds()
				dismiss()
			}
		} message: {
			Text(usedVM.message)
		}
	}
	
	private var usedAddImageView: some View {
		HStack {
			Button {
				if selectedImages.count < 10 {
					isPickerPresented.toggle()
					print(selectedImages.count)
				}else{
					showAlert = true
					message = "이미지는 10개까지 선택할 수 있습니다."
				}
			} label: {
				Image(systemName: "camera").resizable().scaledToFit().frame(width: 20,height: 20).foregroundColor(.gray).padding(10)
			}.photosPicker(isPresented: $isPickerPresented, selection: $selectedItems, maxSelectionCount: maxImageCount - selectedImages.count, matching: .images)
				.alert(isPresented: $showAlert) {
					Alert(
						title: Text("알림"),
						message: Text(message),
						dismissButton: .default(Text("확인"))
					)
				}
				.frame(width: 100, height: 100)
				.background(Color.white)
				.cornerRadius(10)
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(Color.gray, lineWidth: 1)
				)
				.padding(10)
			
			ScrollView(.horizontal, showsIndicators: false) {
				HStack {
					ForEach(Array(selectedImages.enumerated()), id: \.element) {index, image in
						ZStack (alignment: .topTrailing){
							Image(uiImage: image)
								.resizable()
								.scaledToFill()
								.frame(width: 100, height: 100)
								.cornerRadius(8)
								.padding(5)
							
							
							Button(action: {
								removeImage(at: index)
							}) {
								Image(systemName: "xmark.circle.fill")
									.foregroundColor(.gray)
									.padding(4)
							}.background(Color.white.opacity(0.7))
								.clipShape(Circle())
								.offset(x: 5, y: -5)
						}
					}
				}.onChange(of: selectedItems) { newItems in
					Task {
						await loadSelectedImages(from: newItems)
					}
				}
			}
		}
	}
	
	func loadSelectedImages(from items: [PhotosPickerItem]) async {
		for item in items {
			if let data = try? await item.loadTransferable(type: Data.self),
				 let image = UIImage(data: data) {
				selectedImages.append(image)
			}
		}
		selectedItems = [] // PhotoPicker 상태 초기화
	}
	
	private var myItemInfoSection : some View {
		VStack{
			HStack{
				Button {
					print("item select")
					isMyItemPresented.toggle()
				} label: {
					Image(systemName: "plus.app").resizable().frame(width: 20,height: 20).foregroundColor(.gray).padding(10)
				}
				.cornerRadius(8)
				.padding(.horizontal)
				.padding(.bottom)
				.sheet(isPresented: $isMyItemPresented) {
					UsedItemListView(selectMyItem: $selectMyItem, isMyItemPresented: $isMyItemPresented, fetchAllItem: false)
						.edgesIgnoringSafeArea(.all)
						.environmentObject(ItemViewModel())
				}
				.frame(width: 40, height: 40)
				Spacer()
			}
			
			
			VStack(alignment: .leading,spacing: 10) {
				if let selectMyItem = selectMyItem {
					Text("Item Info")
						.font(.headline)
						.foregroundColor(.gray)
						.padding(.horizontal)
					VStack {
						itemInfo(title: "구매일자", selectMyItem: formatDateString(selectMyItem.purchaseDate))
						itemInfo(title: "구매가격", selectMyItem: selectMyItem.price.map { "\($0)" ?? "" })
						itemInfo(title: "유통기한", selectMyItem: formatDateString(selectMyItem.expiryDate))
						itemInfo(title: "개봉일자", selectMyItem: formatDateString(selectMyItem.openDate))
						itemInfo(title: "제품명", selectMyItem: selectMyItem.itemName)
						itemInfo(title: "추가설명", selectMyItem: selectMyItem.desc)
					}
					.padding()
					.background(Color.white)
					.cornerRadius(16)
					.shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
					.padding(.horizontal)
				} else {
					Text("내 아이템 정보를 선택하세요").padding(.horizontal).padding(.bottom)
				}
			}
		}
	}
	
	
	private var usedTitleSection : some View {
		VStack {
			Text("제목")
				.font(.headline)
				.foregroundColor(.gray)
				.padding(.horizontal)
				.frame(maxWidth: .infinity, alignment: .leading)
			TextField("제목", text: $usedTitle)
				.padding()
				.padding(.horizontal)
				.focused($titleIsFocused)
				.overlay(
					titleError != nil ?
					Text(titleError!)
						.foregroundColor(.red)
						.font(.caption)
						.padding(.top, 4)
						.padding(.horizontal, 20)
					: nil,
					alignment: .bottomLeading
				).background(
					RoundedRectangle(cornerRadius: 16)
						.stroke(Color.gray, lineWidth: 2)
						.background(Color.white)
						.cornerRadius(16)
				)
		}.padding(.horizontal)
	}
	
	private var usedPriceSection : some View {
		VStack {
			Text("가격")
				.font(.headline)
				.foregroundColor(.gray)
				.padding(.horizontal)
				.frame(maxWidth: .infinity, alignment: .leading)
			TextField("가격을 입력해주세요",  text: Binding(
				get: { String(usedPrice) }, // Int를 String으로 변환
				set: { usedPrice = Int($0) ?? 0 } // String을 Int로 변환
			))
			.keyboardType(.numberPad)
			.padding()
			.padding(.horizontal)
			.background(
				RoundedRectangle(cornerRadius: 16)
					.stroke(Color.gray, lineWidth: 2)
					.background(Color.white)
					.cornerRadius(16)
			)
		}.padding(.horizontal)
	}
	
	private var usedDescSection : some View {
		VStack {
			Text("자세한 설명")
				.font(.headline)
				.foregroundColor(.gray)
				.padding(.horizontal)
				.frame(maxWidth: .infinity, alignment: .leading)
			TextEditor(text: $usedContent)
				.frame(height: 200)
				.focused($contentIsFocused)
				.padding()
				.padding(.horizontal)
				.overlay(
					contentError != nil ?
					Text(contentError!)
						.foregroundColor(.red)
						.font(.caption)
						.padding(.top, 4)
						.padding(.horizontal, 8)
					: nil,
					alignment: .bottomLeading
				).background(
					RoundedRectangle(cornerRadius: 16)
						.stroke(Color.gray, lineWidth: 2)
						.background(Color.white)
						.cornerRadius(16)
				)
		}.padding(.horizontal)
	}
	
	private func removeImage(at index: Int) {
		selectedImages.remove(at: index)
	}
	
	private func itemInfo(title:String,selectMyItem:String?) -> some View {
		HStack {
			Text(title)
				.font(.body)
				.foregroundColor(.secondary)
			Spacer()
			if let selectMyItem = selectMyItem {
				Text(selectMyItem.isEmpty ? "" : selectMyItem)
					.font(.body)
					.foregroundColor(.primary)
					.padding(10)
					.frame(minWidth:250,alignment: .leading)
					.background(Color.gray.opacity(0.2))
					.cornerRadius(8)
					.overlay(
						RoundedRectangle(cornerRadius: 8)
							.stroke(Color.gray.opacity(0.2), lineWidth: 1)
					)
			}
		}
	}
	func formatDateString(_ dateString: String?) -> String {
		
		let inputFormatter = DateFormatter()
		inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		
		let outputFormatter = DateFormatter()
		outputFormatter.dateFormat = "yyyy-MM-dd"
		
		
		if let dateString = dateString,
			 let date = inputFormatter.date(from: dateString) {
			return outputFormatter.string(from: date)
		}
		return "Invalid Date"
	}
}



//#Preview {
//    let used = UsedViewModel()
//    UsedAddView().environmentObject(used)
//
//}
