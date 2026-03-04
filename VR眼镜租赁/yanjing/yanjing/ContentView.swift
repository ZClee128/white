//
//  ContentView.swift
//  yanjing
//
//  Created by zclee on 2026/3/4.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            CartView()
                .tabItem {
                    Label("Cart", systemImage: "cart.fill")
                }
                .badge(appState.cart.count > 0 ? "\(appState.cart.count)" : nil)
            
            OrdersView()
                .tabItem {
                    Label("Orders", systemImage: "doc.text.fill")
                }
                .badge(appState.orders.filter { $0.status == .pendingPayment }.count > 0 ? "!" : nil)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(.primary)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
