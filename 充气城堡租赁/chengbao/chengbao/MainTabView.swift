import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    // Custom tab bar styling to avoid 4.3 simple tabview
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                if selectedTab == 0 {
                    HomeView()
                } else if selectedTab == 1 {
                    MyOrdersView()
                } else if selectedTab == 2 {
                    LeaderboardView()
                } else {
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom Tab Bar
            HStack(spacing: 0) {
                TabBarButton(imageName: "house.fill", text: "Discover", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                
                TabBarButton(imageName: "doc.plaintext.fill", text: "My Rentals", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                
                TabBarButton(imageName: "trophy.fill", text: "Rankings", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
                
                TabBarButton(imageName: "gearshape.fill", text: "Settings", isSelected: selectedTab == 3) {
                    selectedTab = 3
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 30) // Safe area
            .background(Color.white.shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5))
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct TabBarButton: View {
    let imageName: String
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: imageName)
                    .font(.system(size: 24, weight: isSelected ? .bold : .regular))
                    .foregroundColor(isSelected ? .black : .gray)
                
                Text(text)
                    .font(.system(size: 10, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? .black : .gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
