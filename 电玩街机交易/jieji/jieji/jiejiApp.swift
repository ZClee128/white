//
//  jiejiApp.swift
//  jieji
//
//  Created by zclee on 2026/3/2.
//

import SwiftUI

@main
struct jiejiApp: App {
    @StateObject private var cartManager = CartManager()
    @StateObject private var addressManager = AddressManager()
    @StateObject private var orderManager = OrderManager()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(cartManager)
                .environmentObject(addressManager)
                .environmentObject(orderManager)
        }
    }
}
