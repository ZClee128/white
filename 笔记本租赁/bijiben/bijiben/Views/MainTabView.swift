import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "laptopcomputer")
                }

            DealsView()
                .tabItem {
                    Label("Deals", systemImage: "bolt.fill")
                }
                
            ProfileView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .tint(Color(hex: "0f3460"))
    }
}

#Preview {
    MainTabView()
        .environment(RentalStore())
}
