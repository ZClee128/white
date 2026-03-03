import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "gamecontroller")
                }
            
            PromotionView()
                .tabItem {
                    Label("Deals", systemImage: "flame.fill")
                }
            
            OrderListView()
                .tabItem {
                    Label("Orders", systemImage: "doc.text")
                }
            
            SettingsView()
                .tabItem {
                    Label("Setting", systemImage: "person.circle")
                }
        }
        .tint(.purple)
    }
}

#Preview {
    ContentView()
        .environmentObject(OrderManager())
}
