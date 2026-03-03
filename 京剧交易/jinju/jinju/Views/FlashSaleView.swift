import SwiftUI
import Combine

struct FlashSaleView: View {
    @EnvironmentObject var store: StoreData
    
    // Countdown Timer Logic
    @State private var timeRemaining = 7200 // 2 hours in seconds
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Select specific figures for flash sale
    var flashSaleFigures: [Figure] {
        // Just take the first 3 items for demonstration
        Array(store.figures.prefix(3))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // 1. Flash Sale Header Banner
                    ZStack(alignment: .bottomLeading) {
                        Image("farewell_my_concubine") // Hardcoded dramatic background
                            .resizable()
                            .scaledToFill()
                            .frame(height: 220)
                            .clipped()
                            .overlay(Color.black.opacity(0.6))
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Flash Sale")
                                .font(.system(size: 32, weight: .heavy, design: .default))
                                .foregroundColor(.white)
                            
                            // Countdown Timer UI
                            HStack {
                                Text("Ends in")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                HStack(spacing: 4) {
                                    TimeBox(text: String(format: "%02d", timeRemaining / 3600))
                                    Text(":").foregroundColor(.white).bold()
                                    TimeBox(text: String(format: "%02d", (timeRemaining % 3600) / 60))
                                    Text(":").foregroundColor(.white).bold()
                                    TimeBox(text: String(format: "%02d", timeRemaining % 60))
                                }
                            }
                        }
                        .padding()
                    }
                    
                    // 2. Flash Sale Product List
                    VStack(spacing: 15) {
                        ForEach(Array(flashSaleFigures.enumerated()), id: \.element.id) { index, figure in
                            // Create a discounted copy of the figure for the detail view
                            let discountedFigure = Figure(
                                id: figure.id,
                                name: figure.name,
                                imageName: figure.imageName,
                                characterRole: figure.characterRole,
                                playName: figure.playName,
                                price: figure.price * 0.7, // Apply flash sale discount
                                description: "[Flash Sale]" + figure.description,
                                colorName: figure.colorName
                            )
                            
                            NavigationLink(destination: DetailView(figure: discountedFigure).environmentObject(store)) {
                                FlashSaleCard(figure: figure, index: index)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                    .background(Color(.systemGroupedBackground))
                }
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
            }
        }
    }
}

struct TimeBox: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(.subheadline, design: .monospaced))
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(Color.red)
            .cornerRadius(4)
    }
}

struct FlashSaleCard: View {
    let figure: Figure
    let index: Int
    
    // Mock progress percentage based on index to look realistic
    var progress: Double {
        return [0.85, 0.62, 0.94][index % 3]
    }
    
    var body: some View {
        HStack(spacing: 15) {
            // Left Image
            Image(figure.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 130, height: 130)
                .cornerRadius(12)
                .clipped()
            
            // Right Content
            VStack(alignment: .leading, spacing: 8) {
                Text(figure.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(1)
                
                Text(figure.playName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Spacer()
                
                // Progress Bar
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Claimed \(Int(progress * 100))%")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.red)
                        Spacer()
                    }
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.red.opacity(0.15)).frame(height: 6)
                            Capsule().fill(Color.red).frame(width: geo.size.width * progress, height: 6)
                        }
                    }
                    .frame(height: 6)
                }
                
                // Price Area
                HStack(alignment: .bottom, spacing: 5) {
                    Text("¥\(String(format: "%.0f", figure.price * 0.7))") // Mock flash sale price
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.red)
                    
                    Text("¥\(String(format: "%.0f", figure.price))")
                        .font(.caption)
                        .strikethrough()
                        .foregroundColor(.gray)
                        .padding(.bottom, 3)
                    
                    Spacer()
                    
                    Text("Grab Now")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.red, .orange]), startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(Capsule())
                }
            }
            .padding(.vertical, 5)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    FlashSaleView()
        .environmentObject(StoreData())
}
