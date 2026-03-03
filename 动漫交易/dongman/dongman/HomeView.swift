import SwiftUI
import Combine

struct HomeView: View {
    @EnvironmentObject var store: DataStore
    @State private var selectedCategory: FigureCategory = .all
    @State private var searchText: String = ""
    @State private var showSearch: Bool = false
    @State private var flashTimeRemaining: TimeInterval = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var filteredFigures: [Figure] {
        let byCategory = store.figures(for: selectedCategory)
        if searchText.isEmpty { return byCategory }
        return byCategory.filter {
            $0.name.lowercased().contains(searchText.lowercased()) ||
            $0.series.lowercased().contains(searchText.lowercased())
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.07, green: 0.07, blue: 0.12).ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Header
                        headerSection

                        // Flash Sale Banner
                        if !store.flashSaleFigures().isEmpty {
                            flashSaleBanner
                                .padding(.horizontal, 16)
                                .padding(.top, 20)
                        }

                        // Categories
                        categoryChips
                            .padding(.top, 20)

                        // Grid
                        figureGrid
                            .padding(.top, 16)
                            .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarHidden(true)
            .onReceive(timer) { _ in
                let remaining = store.flashSaleEndDate.timeIntervalSince(Date())
                flashTimeRemaining = max(0, remaining)
            }
            .onAppear {
                flashTimeRemaining = max(0, store.flashSaleEndDate.timeIntervalSince(Date()))
            }
        }
    }

    // MARK: - Subviews

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("AniTrade")
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(.white)
                Text("Find your next treasure")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button {
                showSearch = true
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 42, height: 42)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }
            .sheet(isPresented: $showSearch) {
                SearchView()
                    .environmentObject(store)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }

    private var flashSaleBanner: some View {
        NavigationLink(destination: ProductDetailView(figure: store.flashSaleFigures()[0]).environmentObject(store)) {
            ZStack {
                LinearGradient(colors: [Color(red: 0.6, green: 0.1, blue: 0.8), Color(red: 0.9, green: 0.2, blue: 0.4)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .cornerRadius(20)

                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Label("FLASH SALE", systemImage: "bolt.fill")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                        Text(store.flashSaleFigures()[0].name)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text(store.flashSaleFigures()[0].series)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        countdownBadge
                    }
                    Spacer()
                    VStack(spacing: 2) {
                        Image(systemName: store.flashSaleFigures()[0].systemImageName)
                            .font(.system(size: 48))
                            .foregroundColor(.white.opacity(0.9))
                        Text("$\(String(format: "%.2f", store.flashSaleFigures()[0].price))")
                            .font(.title2)
                            .fontWeight(.black)
                            .foregroundColor(.yellow)
                    }
                }
                .padding(20)
            }
            .frame(height: 130)
        }
        .buttonStyle(.plain)
    }

    private var countdownBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "clock")
            Text(formatTime(flashTimeRemaining))
                .monospacedDigit()
        }
        .font(.caption)
        .fontWeight(.semibold)
        .foregroundColor(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(Color.black.opacity(0.35))
        .cornerRadius(8)
    }

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(FigureCategory.allCases, id: \.self) { cat in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            selectedCategory = cat
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: cat.icon)
                                .font(.caption)
                            Text(cat.rawValue)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 9)
                        .background(selectedCategory == cat ?
                            Color(red: 0.42, green: 0.36, blue: 0.91) :
                            Color.white.opacity(0.08))
                        .foregroundColor(selectedCategory == cat ? .white : .gray)
                        .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private var figureGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 14) {
            ForEach(filteredFigures) { figure in
                NavigationLink(destination: ProductDetailView(figure: figure).environmentObject(store)) {
                    FigureCard(figure: figure)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
    }

    private func formatTime(_ interval: TimeInterval) -> String {
        let h = Int(interval) / 3600
        let m = (Int(interval) % 3600) / 60
        let s = Int(interval) % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
}

// MARK: - Figure Card

struct FigureCard: View {
    let figure: Figure

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
                // Image area
            ZStack(alignment: .bottom) {
                Color(red: 0.12, green: 0.12, blue: 0.18)
                    .frame(height: 140)
                    .cornerRadius(14)

                Image(figure.systemImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 140)
                    .clipped()
                    .cornerRadius(14)

                VStack {
                    HStack {
                        if figure.isFlashSale {
                            Label("SALE", systemImage: "bolt.fill")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(Color.yellow)
                                .cornerRadius(6)
                        }
                        Spacer()
                        Text(figure.condition.rawValue)
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(figure.condition.color)
                            .cornerRadius(6)
                    }
                    Spacer()
                }
                .padding(8)
            }

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(figure.name)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text(figure.series)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                HStack(alignment: .bottom, spacing: 6) {
                    Text("$\(String(format: "%.2f", figure.price))")
                        .font(.subheadline)
                        .fontWeight(.black)
                        .foregroundColor(Color(red: 0.42, green: 0.36, blue: 0.91))
                    if figure.discountPercent > 0 {
                        Text("-\(figure.discountPercent)%")
                            .font(.caption)
                            .foregroundColor(.pink)
                    }
                }
                // Seller rating
                HStack(spacing: 3) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 9))
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", figure.seller.rating))
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Text("·")
                        .foregroundColor(.gray)
                        .font(.caption2)
                    Text(figure.seller.name)
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
        }
        .background(Color(red: 0.1, green: 0.1, blue: 0.15))
        .cornerRadius(16)
    }

    private func accentColor(_ hex: String) -> Color {
        let cleaned = hex.replacing("#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        return Color(red: r, green: g, blue: b)
    }
}
