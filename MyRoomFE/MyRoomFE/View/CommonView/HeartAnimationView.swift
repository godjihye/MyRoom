//
//  HeartAnimationView.swift
//  MyRoomFE
//
//  Created by jhshin on 12/9/24.
//

import SwiftUI

struct HeartAnimationView: View {
		@State private var hearts: [Heart] = []
		@State private var counter = 0
		
		var body: some View {
				ZStack {
						// 하트 애니메이션 레이어
						ForEach(hearts) { heart in
								Image(systemName: "heart.fill")
										.resizable()
										.foregroundColor(.pink)
										.frame(width: heart.size, height: heart.size)
										.position(x: heart.startX, y: heart.startY)
										.offset(y: heart.offsetY)
										.opacity(heart.opacity)
										.animation(
												Animation.easeOut(duration: heart.duration)
														.delay(heart.delay),
												value: heart.offsetY
										)
						}
						
						// 좋아요 버튼
						VStack {
								Spacer()
								Button(action: addMultipleHearts) { // 버튼 동작 수정
										HStack {
												Image(systemName: "hand.thumbsup.fill")
														.font(.title)
												Text("좋아요")
														.font(.title2)
										}
										.foregroundColor(.white)
										.padding()
										.background(Color.blue)
										.cornerRadius(10)
								}
								.padding(.bottom, 50)
						}
				}
				.background(Color.black.opacity(0.05).ignoresSafeArea())
		}
		
		// 하트를 한 번에 여러 개 추가하는 함수
		func addMultipleHearts() {
				let numberOfHearts = 20 // 하트의 개수
				
				// 새로운 하트 여러 개 추가
				for _ in 0..<numberOfHearts {
						let newHeart = Heart(
								id: counter,
								startX: CGFloat.random(in: 50...UIScreen.main.bounds.width - 50),
								startY: UIScreen.main.bounds.height - 100,
								size: CGFloat.random(in: 20...40),
								duration: Double.random(in: 2...4),
								delay: Double.random(in: 0...0.3)
						)
						hearts.append(newHeart)
						counter += 1
				}
				
				// 일정 시간 뒤 하트 제거
				DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
						hearts.removeAll { $0.id < counter - numberOfHearts }
				}
		}
}

struct Heart: Identifiable {
		let id: Int
		let startX: CGFloat
		let startY: CGFloat
		let size: CGFloat
		let duration: Double
		let delay: Double
		
		var offsetY: CGFloat {
				-UIScreen.main.bounds.height / 2 // 위로 이동
		}
		
		var opacity: Double {
				0 // 사라지면서 투명도 변화
		}
}

struct HeartAnimationView_Previews: PreviewProvider {
		static var previews: some View {
				HeartAnimationView()
		}
}
