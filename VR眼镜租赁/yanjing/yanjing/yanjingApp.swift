//
//  yanjingApp.swift
//  yanjing
//
//  Created by zclee on 2026/3/4.
//

import SwiftUI

@main
struct yanjingApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
