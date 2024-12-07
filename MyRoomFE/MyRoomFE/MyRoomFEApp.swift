//
//  MyRoomFEApp.swift
//  MyRoomFE
//
//  Created by jhshin on 11/14/24.
//

import SwiftUI
import FirebaseCore
import KakaoSDKCommon

@main
struct MyRoomFEApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
	func application(_ application: UIApplication,
									 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		FirebaseApp.configure()
		KakaoSDK.initSDK(appKey: "d73f6c5078a62fcebff4acd52f62de6b")
		return true
	}
}
