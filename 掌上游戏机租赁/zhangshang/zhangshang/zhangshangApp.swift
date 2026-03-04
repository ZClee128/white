//
//  zhangshangApp.swift
//  zhangshang
//
//  Created by zclee on 2026/3/1.
//

import SwiftUI

@main
struct zhangshangApp: App {
    @StateObject private var orderManager = OrderManager()
    @StateObject private var addressManager = AddressManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(orderManager)
                .environmentObject(addressManager)
                .preferredColorScheme(.light)
        }
    }
}
