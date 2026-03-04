//
//  bijibenApp.swift
//  bijiben
//
//  Created by zclee on 2026/2/28.
//

import SwiftUI

@main
struct bijibenApp: App {
    @StateObject private var store = RentalStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .preferredColorScheme(.light)
        }
    }
}

