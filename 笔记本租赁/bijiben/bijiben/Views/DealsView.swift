import SwiftUI
import Combine

struct DealsView: View {
    @EnvironmentObject var store: RentalStore
    
    // Timer state for the flash sale countdown
    @State private var timeRemaining = 3600 * 5 + 60 * 23 // 5h 23m remaining
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var flashSaleLaptops: [Laptop] {
        // Just picking the first two laptops to simulate a flash sale
        var laptops = Array(store.laptops.prefix(2))
        for i in 0..<laptops.count {
            laptops[i].isDiscounted = true
        }
        return laptops
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 20) {
                        // Flash Sale Header Badge
                        flashSaleHeader
                        
                        // Flash Sale Items
                        LazyVStack(spacing: 20) {
                            ForEach(flashSaleLaptops) { laptop in
                                NavigationLink(value: laptop) {
                                    FlashSaleCard(laptop: laptop)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        // Promotional Banner
                        promoBanner
                            .padding(.top, 10)
                    }
                    .padding(.vertical, 16)
                }
                .background(Color(.systemGroupedBackground))
                .navigationTitle("Exclusive Deals")
                .navigationBarTitleDisplayMode(.large)
                .navigationDestination(for: Laptop.self) { laptop in
                    ProductDetailView(laptop: laptop)
                }
                .onReceive(timer) { _ in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }

    private var flashSaleHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.yellow)
                    Text("FLASH RENTAL")
                        .font(.headline.bold())
                        .foregroundColor(Color(hex: "0f3460"))
                }
                Text("Ends in \(timeString(time: timeRemaining))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            // Countdown visual indicator
            HStack(spacing: 4) {
                let time = timeComponents(time: timeRemaining)
                TimeBox(value: time.hours)
                Text(":").bold()
                TimeBox(value: time.minutes)
                Text(":").bold()
                TimeBox(value: time.seconds)
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var promoBanner: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "e94560"), Color(hex: "c0392b")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("New User Promo")
                        .font(.caption.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(.white.opacity(0.2)))
                        .foregroundColor(.white)
                    
                    Text("Unlock 20% OFF")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    Text("On your first weekly rental.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                Spacer()
                Image(systemName: "gift.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.trailing, 10)
            }
            .padding(20)
        }
        .padding(.horizontal, 16)
    }

    private func timeComponents(time: Int) -> (hours: String, minutes: String, seconds: String) {
        let h = time / 3600
        let m = (time % 3600) / 60
        let s = time % 60
        return (
            String(format: "%02d", h),
            String(format: "%02d", m),
            String(format: "%02d", s)
        )
    }

    private func timeString(time: Int) -> String {
        let comp = timeComponents(time: time)
        return "\(comp.hours)h \(comp.minutes)m"
    }
}

struct TimeBox: View {
    let value: String
    var body: some View {
        Text(value)
            .font(.caption.bold())
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(RoundedRectangle(cornerRadius: 4).fill(Color(hex: "0f3460")))
    }
}

// MARK: - Flash Sale Card
struct FlashSaleCard: View {
    let laptop: Laptop

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(Color(hex: "1a1a2e"))
                    .frame(height: 140)
                
                Image(laptop.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(16)
                
                // Discount Badge
                Text("-30%")
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hex: "e94560"))
                    )
                    .padding(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(laptop.brand.uppercased())
                        .font(.caption2.bold())
                        .foregroundColor(.secondary)
                    Spacer()
                    // Progress bar representing "Stock claimed"
                    ProgressView(value: 0.8)
                        .frame(width: 60)
                        .tint(Color(hex: "e94560"))
                    Text("80% Claimed")
                        .font(.caption2)
                        .foregroundColor(Color(hex: "e94560"))
                }
                
                Text(laptop.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(alignment: .bottom, spacing: 6) {
                    let discountedPrice = Int(laptop.dailyPrice * 0.7)
                    Text("$\(discountedPrice)")
                        .font(.title2.bold())
                        .foregroundColor(Color(hex: "e94560"))
                    
                    Text("$\(Int(laptop.dailyPrice))")
                        .font(.subheadline)
                        .strikethrough()
                        .foregroundColor(.secondary)
                        .padding(.bottom, 2)
                    
                    Text("/day")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 2)
                    
                    Spacer()
                    
                    Text("Rent Now")
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(Color(hex: "e94560")))
                }
            }
            .padding(16)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
    }
}

#Preview {
    DealsView()
        .environmentObject(RentalStore())
}
