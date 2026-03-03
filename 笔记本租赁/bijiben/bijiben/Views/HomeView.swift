import SwiftUI

struct HomeView: View {
    @Environment(RentalStore.self) var store
    @State private var searchText = ""
    @State private var selectedBrand: String? = nil

    let brands = ["All", "Apple", "Lenovo", "Dell", "HP", "ASUS", "Microsoft", "Razer"]

    var filteredLaptops: [Laptop] {
        store.laptops.filter { laptop in
            let matchesBrand = selectedBrand == nil || selectedBrand == "All" || laptop.brand == selectedBrand
            let matchesSearch = searchText.isEmpty || laptop.name.localizedCaseInsensitiveContains(searchText) || laptop.brand.localizedCaseInsensitiveContains(searchText)
            return matchesBrand && matchesSearch
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Hero Banner
                    heroBanner

                    // Brand Filter
                    brandFilter
                        .padding(.vertical, 16)

                    // Featured Laptops (Horizontal)
                    if selectedBrand == nil || selectedBrand == "All" {
                        featuredSection
                    }

                    // All Models Header
                    HStack {
                        Text(selectedBrand == nil || selectedBrand == "All" ? "All Models" : "\(selectedBrand!) Models")
                            .font(.title3.bold())
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)

                    // Laptop Grid
                    LazyVStack(spacing: 16) {
                        ForEach(filteredLaptops) { laptop in
                            NavigationLink(value: laptop) {
                                LaptopCard(laptop: laptop)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Rent a Laptop")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search laptops...")
            .navigationDestination(for: Laptop.self) { laptop in
                ProductDetailView(laptop: laptop)
            }
        }
    }

    // MARK: Hero Banner
    private var heroBanner: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [Color(hex: "1a1a2e"), Color(hex: "16213e"), Color(hex: "0f3460")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 200)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "laptopcomputer")
                        .font(.caption)
                        .foregroundColor(Color(hex: "e94560"))
                    Text("PREMIUM RENTALS")
                        .font(.caption.bold())
                        .foregroundColor(Color(hex: "e94560"))
                        .tracking(2)
                }

                Text("Top Laptops,\nRent by Day.")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .lineSpacing(4)

                Text("No commitment. Cancel anytime.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(24)

            // Decorative circles
            Circle()
                .fill(.white.opacity(0.04))
                .frame(width: 180, height: 180)
                .offset(x: 240, y: -40)

            Circle()
                .fill(.white.opacity(0.04))
                .frame(width: 120, height: 120)
                .offset(x: 300, y: 30)
        }
    }

    // MARK: Brand Filter
    private var brandFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(brands, id: \.self) { brand in
                    BrandChip(
                        title: brand,
                        isSelected: (selectedBrand ?? "All") == brand
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedBrand = brand == "All" ? nil : brand
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    // MARK: Featured Section
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Trending Now")
                    .font(.title3.bold())
                Spacer()
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(store.laptops.prefix(3)) { laptop in
                        NavigationLink(value: laptop) {
                            FeaturedCard(laptop: laptop)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.bottom, 24)
    }
}

// MARK: - Featured Card
struct FeaturedCard: View {
    let laptop: Laptop

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(laptop.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 120)
                .background(Color(hex: "f4f4f4"))
                .cornerRadius(16)

            VStack(alignment: .leading, spacing: 4) {
                Text(laptop.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(laptop.processor)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                Text("$\(Int(laptop.dailyPrice))/day")
                    .font(.subheadline.bold())
                    .foregroundColor(Color(hex: "0f3460"))
                    .padding(.top, 2)
            }
            .padding(.horizontal, 4)
        }
        .frame(width: 200)
    }
}

// MARK: - Brand Chip
struct BrandChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color(hex: "0f3460") : Color(.systemBackground))
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : Color(.separator), lineWidth: 1)
                )
        }
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

// MARK: - Laptop Card
struct LaptopCard: View {
    let laptop: Laptop

    var body: some View {
        HStack(spacing: 16) {
            Image(laptop.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .background(Color(hex: "f4f4f4"))
                .cornerRadius(16)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(laptop.brand.uppercased())
                        .font(.caption2.bold())
                        .foregroundColor(.secondary)
                        .tracking(1)

                    Spacer()

                    if !laptop.isAvailable {
                        Text("Unavailable")
                            .font(.caption2.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(Color.gray))
                    }
                }

                Text(laptop.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text("\(laptop.processor) · \(laptop.ram)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text("$\(Int(laptop.dailyPrice))")
                        .font(.title3.bold())
                        .foregroundColor(Color(hex: "0f3460"))

                    Text("/day")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        )
        .opacity(laptop.isAvailable ? 1 : 0.6)
    }

    func brandGradient(for brand: String) -> LinearGradient {
        switch brand {
        case "Apple":
            return LinearGradient(colors: [Color(hex: "636e72"), Color(hex: "2d3436")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "Lenovo":
            return LinearGradient(colors: [Color(hex: "e55039"), Color(hex: "c0392b")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "Dell":
            return LinearGradient(colors: [Color(hex: "0984e3"), Color(hex: "2c3e50")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "HP":
            return LinearGradient(colors: [Color(hex: "6c5ce7"), Color(hex: "a29bfe")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "ASUS":
            return LinearGradient(colors: [Color(hex: "00b894"), Color(hex: "00cec9")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "Microsoft":
            return LinearGradient(colors: [Color(hex: "00b4d8"), Color(hex: "0077b6")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "Razer":
            return LinearGradient(colors: [Color(hex: "00b300"), Color(hex: "005c00")], startPoint: .topLeading, endPoint: .bottomTrailing)
        default:
            return LinearGradient(colors: [Color(hex: "636e72"), Color(hex: "2d3436")], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    HomeView()
        .environment(RentalStore())
}
