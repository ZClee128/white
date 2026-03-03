import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var showingDetail = false
    @State private var selectedCard: BouncyCastle?
    @State private var goHome = false
    
    let categories = ["All", "Castles", "Slides", "Combos", "Water", "Obstacles"]
    @State private var selectedCategory = "All"
    
    var body: some View {
        Group {
            ZStack {
                Color(hex: "#FAFAFA").edgesIgnoringSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Bouncy Castle")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(.black.opacity(0.6))
                                Text("Premium Rentals")
                                    .font(.system(size: 32, weight: .black, design: .rounded))
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            
//                            Image(systemName: "bell.badge.fill")
//                                .font(.system(size: 24))
//                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        
                        // Promotional Banner
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: "#FF9A9E"), Color(hex: "#FECFEF")]), startPoint: .leading, endPoint: .trailing))
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Special Offer!")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white.opacity(0.8))
                                Text("Get 15% off your\nfirst rental.")
                                    .font(.system(size: 22, weight: .black))
                                    .foregroundColor(.white)
                            }
                            .padding(24)
                        }
                        .frame(height: 120)
                        .padding(.horizontal, 24)
                        
                        // Categories
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Categories")
                                .font(.system(size: 20, weight: .bold))
                                .padding(.horizontal, 24)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(categories, id: \.self) { category in
                                        Text(category)
                                            .font(.system(size: 16, weight: selectedCategory == category ? .bold : .medium))
                                            .foregroundColor(selectedCategory == category ? .white : .black)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                            .background(selectedCategory == category ? Color.black : Color.white)
                                            .cornerRadius(20)
                                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                            .onTapGesture {
                                                selectedCategory = category
                                            }
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                        
                        // Featured Carousel
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Featured")
                                .font(.system(size: 20, weight: .bold))
                                .padding(.horizontal, 24)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(dataStore.bouncyCastles.prefix(4)) { castle in
                                        FeaturedCardView(castle: castle)
                                            .onTapGesture {
                                                selectedCard = castle
                                                goHome = true
                                            }
                                    }
                                }
                                .padding(.horizontal, 24)
                                .padding(.bottom, 10)
                            }
                        }
                        
                        // Popular List
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Popular Right Now")
                                .font(.system(size: 20, weight: .bold))
                                .padding(.horizontal, 24)
                            
                            VStack(spacing: 16) {
                                ForEach(dataStore.bouncyCastles.dropFirst(4)) { castle in
                                    PopularRowView(castle: castle)
                                        .onTapGesture {
                                            selectedCard = castle
                                            goHome = true
                                        }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        
                        // Leaderboard
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("🏆 Top Rentals")
                                    .font(.system(size: 20, weight: .bold))
                                Spacer()
                                Text("This Month")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 24)
                            
                            VStack(spacing: 0) {
                                ForEach(Array(dataStore.bouncyCastles.prefix(5).enumerated()), id: \.offset) { index, castle in
                                    LeaderboardRowView(rank: index + 1, castle: castle)
                                        .onTapGesture {
                                            selectedCard = castle
                                            goHome = true
                                        }
                                    if index < 4 {
                                        Divider().padding(.leading, 72)
                                    }
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                            .padding(.horizontal, 24)
                        }
                        
                        Spacer().frame(height: 140)

                    }
                }
            }
            .navigationBarHidden(true)
            .background(
                NavigationLink(
                    destination: DetailView(castle: selectedCard ?? dataStore.bouncyCastles[0], goHome: $goHome),
                    isActive: $goHome
                ) { EmptyView() }
            )
        }
    }
}

struct FeaturedCardView: View {
    let castle: BouncyCastle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Image(castle.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .clipped()
                
                Text("$\(String(format: "%.0f", castle.pricePerDay))")
                    .font(.system(size: 14, weight: .bold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(12)
            }
            .frame(height: 180)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(castle.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Text(castle.headline)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .padding(16)
        }
        .frame(width: 240)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

struct PopularRowView: View {
    let castle: BouncyCastle
    
    var body: some View {
        HStack(spacing: 16) {
            Image(castle.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(castle.name)
                    .font(.system(size: 16, weight: .bold))
                Text(castle.dimensions)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("$\(String(format: "%.0f", castle.pricePerDay))")
                .font(.system(size: 16, weight: .bold))
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct LeaderboardRowView: View {
    let rank: Int
    let castle: BouncyCastle
    
    // Simulated rental counts
    private let rentalCounts = [428, 371, 310, 256, 198]
    
    var medalLabel: some View {
        ZStack {
            Circle()
                .fill(medalColor.opacity(0.15))
                .frame(width: 36, height: 36)
            Text(rank <= 3 ? ["🥇","🥈","🥉"][rank-1] : "\(rank)")
                .font(.system(size: rank <= 3 ? 20 : 15, weight: .bold))
                .foregroundColor(medalColor)
        }
    }
    
    var medalColor: Color {
        switch rank {
        case 1: return Color(hex: "#FFD700")
        case 2: return Color(hex: "#C0C0C0")
        case 3: return Color(hex: "#CD7F32")
        default: return .gray
        }
    }
    
    var body: some View {
        HStack(spacing: 14) {
            medalLabel
            
            Image(castle.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 3) {
                Text(castle.name)
                    .font(.system(size: 15, weight: .bold))
                    .lineLimit(1)
                Text("$\(String(format: "%.0f", castle.pricePerDay))/day")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(rank < rentalCounts.count ? rentalCounts[rank-1] : 100)")
                    .font(.system(size: 16, weight: .black))
                    .foregroundColor(.black)
                Text("rentals")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

// Helper for Hex Colors (kept for completeness if replaced in same file)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 255, 255, 255)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
