import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var selectedCard: BouncyCastle?
    @State private var goToDetail = false
    @State private var animateIn = false
    
    // Simulated rental numbers per castle (indexed by position)
    private let rentalCounts = [428, 371, 310, 256, 198, 187, 174, 162, 155, 143, 138, 129, 116]
    
    var body: some View {
        ZStack {
            // Dark gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#0A0A0A"), Color(hex: "#1A1A2E"), Color(hex: "#16213E")]),
                startPoint: .top, endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 8) {
                        Text("🏆")
                            .font(.system(size: 48))
                            .scaleEffect(animateIn ? 1.0 : 0.5)
                            .animation(.spring(response: 0.6, dampingFraction: 0.6), value: animateIn)
                        
                        Text("Top Rentals")
                            .font(.system(size: 34, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Most booked this month")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 32)
                    
                    // Top 3 Podium
                    HStack(alignment: .bottom, spacing: 12) {
                        // #2
                        if dataStore.bouncyCastles.count > 1 {
                            PodiumCard(
                                rank: 2,
                                castle: dataStore.bouncyCastles[1],
                                count: rentalCounts[1],
                                height: 100,
                                medalGradient: [Color(hex: "#C0C0C0"), Color(hex: "#A8A9AD")],
                                animateIn: animateIn
                            )
                            .onTapGesture {
                                selectedCard = dataStore.bouncyCastles[1]
                                goToDetail = true
                            }
                        }
                        
                        // #1 — tallest
                        if dataStore.bouncyCastles.count > 0 {
                            PodiumCard(
                                rank: 1,
                                castle: dataStore.bouncyCastles[0],
                                count: rentalCounts[0],
                                height: 130,
                                medalGradient: [Color(hex: "#FFD700"), Color(hex: "#FFA500")],
                                animateIn: animateIn
                            )
                            .onTapGesture {
                                selectedCard = dataStore.bouncyCastles[0]
                                goToDetail = true
                            }
                        }
                        
                        // #3
                        if dataStore.bouncyCastles.count > 2 {
                            PodiumCard(
                                rank: 3,
                                castle: dataStore.bouncyCastles[2],
                                count: rentalCounts[2],
                                height: 80,
                                medalGradient: [Color(hex: "#CD7F32"), Color(hex: "#A0522D")],
                                animateIn: animateIn
                            )
                            .onTapGesture {
                                selectedCard = dataStore.bouncyCastles[2]
                                goToDetail = true
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                    
                    // Ranked list (4–13)
                    VStack(spacing: 0) {
                        ForEach(Array(dataStore.bouncyCastles.dropFirst(3).prefix(10).enumerated()), id: \.offset) { index, castle in
                            let rank = index + 4
                            let count = rank - 1 < rentalCounts.count ? rentalCounts[rank - 1] : 100
                            
                            HStack(spacing: 14) {
                                // Rank badge
                                Text("\(rank)")
                                    .font(.system(size: 16, weight: .black, design: .rounded))
                                    .foregroundColor(.white.opacity(0.4))
                                    .frame(width: 28)
                                
                                // Castle thumbnail
                                Image(castle.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 46, height: 46)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(castle.name)
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                    Text("$\(String(format: "%.0f", castle.pricePerDay))/day")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.45))
                                }
                                
                                Spacer()
                                
                                // Bar + count
                                VStack(alignment: .trailing, spacing: 3) {
                                    Text("\(count)")
                                        .font(.system(size: 15, weight: .black))
                                        .foregroundColor(.white)
                                    
                                    // Mini progress bar
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.white.opacity(0.1))
                                            .frame(width: 60, height: 4)
                                        
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(LinearGradient(
                                                gradient: Gradient(colors: [Color(hex: "#FFD700"), Color(hex: "#FF6B6B")]),
                                                startPoint: .leading, endPoint: .trailing
                                            ))
                                            .frame(width: animateIn ? CGFloat(count) / CGFloat(rentalCounts[0]) * 60 : 0, height: 4)
                                            .animation(.easeOut(duration: 0.8).delay(Double(index) * 0.05), value: animateIn)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .background(Color.white.opacity(0.03))
                            .onTapGesture {
                                selectedCard = castle
                                goToDetail = true
                            }
                            
                            if index < 9 {
                                Divider()
                                    .background(Color.white.opacity(0.06))
                                    .padding(.leading, 20)
                            }
                        }
                    }
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(20)
                    .padding(.horizontal, 16)
                    
                    Spacer().frame(height: 140)
                }
            }
            
            // Hidden NavigationLink
            NavigationLink(
                destination: DetailView(castle: selectedCard ?? dataStore.bouncyCastles[0], goHome: $goToDetail),
                isActive: $goToDetail
            ) { EmptyView() }
        }
        .navigationBarHidden(true)
        .onAppear { animateIn = true }
    }
}

struct PodiumCard: View {
    let rank: Int
    let castle: BouncyCastle
    let count: Int
    let height: CGFloat
    let medalGradient: [Color]
    let animateIn: Bool
    
    private let medals = ["🥇", "🥈", "🥉"]
    
    var body: some View {
        VStack(spacing: 8) {
            // Castle icon
            ZStack {
                Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: medalGradient), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 56, height: 56)
                    .shadow(color: medalGradient[0].opacity(0.5), radius: 8, x: 0, y: 4)
                
                Image(castle.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
            .scaleEffect(animateIn ? 1.0 : 0.3)
            .animation(.spring(response: 0.7, dampingFraction: 0.55).delay(Double(rank == 1 ? 0 : rank == 2 ? 0.1 : 0.2)), value: animateIn)
            
            Text(medals[rank - 1])
                .font(.system(size: 22))
            
            Text(castle.name)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 90)
            
            Text("\(count) rentals")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
            
            // Podium block
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(gradient: Gradient(colors: medalGradient.map { $0.opacity(0.3) }), startPoint: .top, endPoint: .bottom))
                .frame(height: animateIn ? height : 0)
                .animation(.easeOut(duration: 0.8).delay(0.2), value: animateIn)
        }
        .frame(maxWidth: .infinity)
    }
}
