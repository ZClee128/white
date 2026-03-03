import SwiftUI
import Combine

struct HomeView: View {
    @EnvironmentObject var store: StoreData
    
    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 15)
    ]
    
    // Auto-scrolling banner support
    @State private var currentBannerIndex = 0
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    // Select top 3 figures for banner
    var bannerFigures: [Figure] {
        Array(store.figures.prefix(3))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Custom Header Title & Subtitle
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Peking Opera Figures")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("National Heritage · Artisan Hand-painted")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // 1. Hero Banner Carousel
                    TabView(selection: $currentBannerIndex) {
                        ForEach(0..<bannerFigures.count, id: \.self) { index in
                            NavigationLink(destination: DetailView(figure: bannerFigures[index])) {
                                BannerCard(figure: bannerFigures[index])
                            }
                            .tag(index)
                        }
                    }
                    .frame(height: 200)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .onReceive(timer) { _ in
                        withAnimation {
                            currentBannerIndex = (currentBannerIndex + 1) % bannerFigures.count
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // 2. Section Title
                    HStack {
                        Text("Masters Collection")
                            .font(.system(size: 22, weight: .bold, design: .serif))
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // 3. Figure Grid
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(store.figures) { figure in
                            NavigationLink(destination: DetailView(figure: figure)) {
                                FigureCard(figure: figure)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationBarHidden(true)
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct BannerCard: View {
    let figure: Figure
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background Image
            GeometryReader { geo in
                Image(figure.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }
            
            // Dark Overlay for text readability
            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.8)]), startPoint: .center, endPoint: .bottom)
            
            // Text Content
            VStack(alignment: .leading, spacing: 5) {
                Text("Limited Editions")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                
                Text(figure.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(figure.playName)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
        }
        .cornerRadius(20)
        .shadow(color: figure.color.opacity(0.4), radius: 8, x: 0, y: 5)
    }
}

struct FigureCard: View {
    let figure: Figure
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Top Image Area
            GeometryReader { geo in
                Image(figure.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }
            .frame(height: 160) // Lock the height of the image area
            
            // Bottom Info Area
            VStack(alignment: .leading, spacing: 6) {
                Text(figure.name)
                    .font(.system(size: 16, weight: .bold, design: .serif))
                    .lineLimit(1)
                
                Text(figure.playName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack {
                    Text(String(format: "¥%.2f", figure.price))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.red)
                    
                    Spacer()
                    
                    Text(figure.characterRole.components(separatedBy: " ").first ?? figure.characterRole)
                        .font(.system(size: 10, weight: .medium))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.gray.opacity(0.15))
                        .foregroundColor(.primary)
                        .cornerRadius(4)
                }
                .padding(.top, 4)
            }
            .padding(12)
            .background(.ultraThinMaterial) // Advanced Blur Material
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    HomeView()
        .environmentObject(StoreData())
}

#Preview {
    HomeView()
        .environmentObject(StoreData())
}
