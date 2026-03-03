import SwiftUI

struct MainTabView: View {
    @StateObject private var store = StoreData()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            FlashSaleView()
                .tabItem {
                    Label("Flash Sale", systemImage: "flame.fill")
                }
            
            CartView()
                .tabItem {
                    Label("Cart", systemImage: "cart.fill")
                }
                .badge(store.cart.count > 0 ? "\(store.cart.count)" : nil)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .environmentObject(store)
    }
}

#Preview {
    MainTabView()
}
