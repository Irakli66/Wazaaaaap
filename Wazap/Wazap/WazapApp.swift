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
    @State private var showSplashScreen = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                LoginView()
                
                if showSplashScreen {
                    LaunchScreen()
                        .transition(.opacity)
                }
            }
            .onAppear {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showSplashScreen = false
                    }
                }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
