import SwiftUI

struct MarketView: View {
    @EnvironmentObject var store: DataStore
    @State private var sortOption: SortOption = .priceAsc
    @State private var filterCondition: FigureCondition? = nil

    enum SortOption: String, CaseIterable {
        case priceAsc = "Price: Low to High"
        case priceDesc = "Price: High to Low"
        case rating = "Best Seller"
        case discount = "Best Deal"
    }

    var sortedFigures: [Figure] {
        var list = store.figures
        if let cond = filterCondition {
            list = list.filter { $0.condition == cond }
        }
        switch sortOption {
        case .priceAsc:  return list.sorted { $0.price < $1.price }
        case .priceDesc: return list.sorted { $0.price > $1.price }
        case .rating:    return list.sorted { $0.seller.rating > $1.seller.rating }
        case .discount:  return list.sorted { $0.discountPercent > $1.discountPercent }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.07, green: 0.07, blue: 0.12).ignoresSafeArea()

                VStack(spacing: 0) {
                    // Controls bar
                    controlsBar
                        .padding(.top, 8)

                    // Condition filter
                    conditionFilterBar
                        .padding(.top, 10)

                    // List
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 12) {
                            ForEach(sortedFigures) { figure in
                                NavigationLink(destination: ProductDetailView(figure: figure).environmentObject(store)) {
                                    MarketRow(figure: figure)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 14)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Market")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    private var controlsBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(SortOption.allCases, id: \.self) { opt in
                    Button {
                        sortOption = opt
                    } label: {
                        Text(opt.rawValue)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(sortOption == opt ?
                                Color(red: 0.42, green: 0.36, blue: 0.91) :
                                Color.white.opacity(0.08))
                            .foregroundColor(sortOption == opt ? .white : .gray)
                            .cornerRadius(16)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private var conditionFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Button {
                    filterCondition = nil
                } label: {
                    Text("All")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(filterCondition == nil ?
                            Color.white.opacity(0.15) :
                            Color.white.opacity(0.05))
                        .foregroundColor(filterCondition == nil ? .white : .gray)
                        .cornerRadius(14)
                }
                ForEach(FigureCondition.allCases, id: \.self) { cond in
                    Button {
                        filterCondition = filterCondition == cond ? nil : cond
                    } label: {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(cond.color)
                                .frame(width: 6, height: 6)
                            Text(cond.rawValue)
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(filterCondition == cond ?
                            cond.color.opacity(0.2) :
                            Color.white.opacity(0.05))
                        .foregroundColor(filterCondition == cond ? cond.color : .gray)
                        .cornerRadius(14)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Market Row

struct MarketRow: View {
    let figure: Figure

    var body: some View {
        HStack(spacing: 14) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(red: 0.12, green: 0.12, blue: 0.2))
                    .frame(width: 76, height: 76)
                Image(figure.systemImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 76, height: 76)
                    .cornerRadius(14)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(figure.name)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Spacer()
                    Text("$\(String(format: "%.2f", figure.price))")
                        .font(.subheadline)
                        .fontWeight(.black)
                        .foregroundColor(Color(red: 0.42, green: 0.36, blue: 0.91))
                }
                Text(figure.series)
                    .font(.caption)
                    .foregroundColor(.gray)
                HStack(spacing: 6) {
                    Text(figure.category.rawValue)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(5)
                    Circle()
                        .fill(figure.condition.color)
                        .frame(width: 7, height: 7)
                    Text(figure.condition.rawValue)
                        .font(.caption)
                        .foregroundColor(figure.condition.color)
                    Spacer()
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", figure.seller.rating))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                HStack(spacing: 4) {
                    Image(systemName: "person.circle.fill")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Text(figure.seller.name)
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Text("·")
                        .foregroundColor(.gray)
                        .font(.caption2)
                    Text(figure.seller.location)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(14)
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
