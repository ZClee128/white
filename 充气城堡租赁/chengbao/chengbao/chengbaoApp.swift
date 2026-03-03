//
//  chengbaoApp.swift
//  chengbao
//
//  Created by zclee on 2026/3/3.
//

import SwiftUI

@main
struct chengbaoApp: App {
    @StateObject private var dataStore = DataStore()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainTabView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(dataStore)
            .preferredColorScheme(.light) // Keeping it bright and clean
        }
    }
}
