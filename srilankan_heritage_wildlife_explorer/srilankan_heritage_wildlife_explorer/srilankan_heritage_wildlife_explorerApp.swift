//
//  testApp.swift
//  test
//
//  Created by janusha on 2025-04-23.
//

//import SwiftUI
//
//@main
//struct testApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ARViewContainer()
//        }
//    }
//}
import SwiftUI
import FirebaseCore
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct srilankan_heritage_wildlife_explorer: App {
 
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      NavigationView {
        LoginView()
      }
    }
  }
}
