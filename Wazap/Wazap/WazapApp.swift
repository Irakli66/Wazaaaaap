//
//  WazapApp.swift
//  Wazap
//
//  Created by irakli kharshiladze on 21.12.24.
//

import SwiftUI
import FirebaseCore

@main
struct WazapApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("isDarkTheme") private var isDarkTheme = false
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .preferredColorScheme(isDarkTheme ? .dark : .light)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
