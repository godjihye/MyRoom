//
//  MyRoomFEApp.swift
//  MyRoomFE
//
//  Created by jhshin on 11/14/24.
//

import SwiftUI
import FirebaseCore
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct MyRoomFEApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	init() {
		// kakao sdk 초기화
		let kakaoNativeAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String ?? ""
		log("kakaoNativeAppKey 457fb67fb4ee80db55d5029c418dad02 == \(kakaoNativeAppKey)")
		KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
	}
	var body: some Scene {
		WindowGroup {
			ContentView().onOpenURL(perform: { url in
				if (AuthApi.isKakaoTalkLoginUrl(url)) {
					log("AuthApi.isKakaoTalkLoginUrl(url)")
					_ = AuthController.handleOpenUrl(url: url)
				}
			})
		}
	}
}

class AppDelegate: UIResponder, UIApplicationDelegate {
	func application(_ application: UIApplication,
									 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		FirebaseApp.configure()
		return true
	}
}
