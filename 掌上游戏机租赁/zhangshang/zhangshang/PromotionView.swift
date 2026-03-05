import SwiftUI
import Combine

struct PromotionView: View {
    let promotions = MockData.promotions
    @State private var currentTime = Date()
    // Timer to update countdown every second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Area
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hot Deals")
                            .font(.system(size: 34, weight: .heavy, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing)
                            )
                        Text("Don't miss out on these limited-time offers!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Promotions List
                    LazyVStack(spacing: 20) {
                        ForEach(promotions) { promo in
                            if let console = MockData.consoles.first(where: { $0.id == promo.discountTargetConsoleId }) {
                                NavigationLink(destination: ConsoleDetailView(console: console, discountedPrice: promo.discountedPrice)) {
                                    PromotionCardView(promotion: promo, console: console, currentTime: currentTime)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .background(Color(UIColor.systemGroupedBackground))
            .onReceive(timer) { _ in
                currentTime = Date()
            }
        }
    }
}

struct PromotionCardView: View {
    let promotion: Promotion
    let console: Console
    let currentTime: Date
    
    var timeRemaining: String {
        let diff = promotion.endTime.timeIntervalSince(currentTime)
        if diff <= 0 { return "Ended" }
        
        let hours = Int(diff) / 3600
        let minutes = (Int(diff) % 3600) / 60
        let seconds = Int(diff) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background Gradient
            LinearGradient(
                colors: [Color(hex: promotion.bannerColorStart) ?? .purple, Color(hex: promotion.bannerColorEnd) ?? .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 200)
            .cornerRadius(20)
            
            // Background Image Overlay (console icon)
            Image(console.name)
                .resizable()
                .scaledToFit()
                .frame(width: 160)
                .opacity(0.6)
                .offset(x: 140, y: 30) // Positioned bottom right
                .rotationEffect(.degrees(-15))
            
            VStack(alignment: .leading, spacing: 12) {
                // Top Tag
                HStack {
                    Text("FLASH SALE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    
                    Spacer()
                    
                    // Countdown clock
                    HStack(spacing: 4) {
                        Image(systemName: "timer")
                        Text(timeRemaining)
                            .font(.system(.subheadline, design: .monospaced))
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.black.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                Spacer()
                
                // Titles
                Text(promotion.title)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                Text(promotion.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                // Pricing row
                HStack(alignment: .bottom) {
                    Text("$\(String(format: "%.1f", promotion.discountedPrice))")
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.yellow)
                    Text("/day")
                        .font(.caption)
                        .foregroundColor(.yellow.opacity(0.8))
                        .padding(.bottom, 4)
                    
                    Text("$\(String(format: "%.0f", promotion.originalPrice))")
                        .font(.subheadline)
                        .strikethrough()
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.bottom, 4)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Rent Now")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .foregroundColor(Color(hex: promotion.bannerColorStart) ?? .purple)
                            .clipShape(Capsule())
                    }
                    // Prevent button tap from overriding NavigationLink tap
                    .allowsHitTesting(false) 
                }
                .padding(.top, 4)
            }
            .padding(20)
        }
        .shadow(color: (Color(hex: promotion.bannerColorStart) ?? .black).opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

// Helper block to convert string hex to Color
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

#Preview {
    PromotionView()
}
