//
//  ContentView.swift
//  test
//
//  Created by janusha on 2025-04-23.
//

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    SplashView()
//}
//struct ContentView: View {
//    var body: some View {
//        MainView()
//            .environmentObject(AuthManager())
//            .environmentObject(LocationManager())
//    }
//}

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainView()
            .environmentObject(AuthManager())
            .environmentObject(LocationManager())
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager())
        .environmentObject(LocationManager())
}
