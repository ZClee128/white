import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var store: DataStore
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            MarketView()
                .tabItem {
                    Label("Market", systemImage: "storefront.fill")
                }
                .tag(1)

            OrdersView()
                .tabItem {
                    Label("Orders", systemImage: "shippingbox.fill")
                }
                .tag(2)

            ProfileView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .accentColor(Color(red: 0.42, green: 0.36, blue: 0.91))
        .preferredColorScheme(.dark)
    }
}
