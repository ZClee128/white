import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    let consoles = MockData.consoles
    
    var filteredConsoles: [Console] {
        if searchText.isEmpty {
            return consoles
        }
        return consoles.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Promotional Banner
                    bannerView
                    
                    // Recommended Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Featured Consoles")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(filteredConsoles) { console in
                                NavigationLink(destination: ConsoleDetailView(console: console)) {
                                    ConsoleCardView(console: console)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("GameHub")
            .searchable(text: $searchText, prompt: "Search consoles...")
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
    
    private var bannerView: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(height: 180)
                .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Weekend Special")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.white.opacity(0.3))
                    .clipShape(Capsule())
                
                Text("Rent 3 Days,\nGet 1 Free")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(20)
        }
        .padding(.horizontal)
        .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

struct ConsoleCardView: View {
    let console: Console
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                Color.gray.opacity(0.1)
                Image(console.name)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
            }
            .frame(height: 120)
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(console.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text("$\(String(format: "%.0f", console.dailyPrice))/day")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.purple)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
        }
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    HomeView()
}
