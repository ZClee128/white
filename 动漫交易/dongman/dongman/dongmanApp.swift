//
//  dongmanApp.swift
//  dongman
//
//  Created by zclee on 2026/2/28.
//

import SwiftUI

@main
struct dongmanApp: App {
    @StateObject private var store = DataStore()
    @StateObject private var addressStore = AddressStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(addressStore)
        }
    }
}
