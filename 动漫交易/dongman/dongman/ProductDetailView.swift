import SwiftUI

struct ProductDetailView: View {
    let figure: Figure
    @EnvironmentObject var store: DataStore
    @EnvironmentObject var addressStore: AddressStore
    @State private var showCheckout: Bool = false
    @State private var showMessage: Bool = false
    @State private var showReportAlert: Bool = false
    @State private var showBlockAlert: Bool = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color(red: 0.07, green: 0.07, blue: 0.12).ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Hero
                    heroSection

                    // Details
                    VStack(alignment: .leading, spacing: 20) {
                        // Title & price
                        titleSection

                        Divider().background(Color.white.opacity(0.08))

                        // Specs
                        specsSection

                        Divider().background(Color.white.opacity(0.08))

                        // Description
                        descriptionSection

                        Divider().background(Color.white.opacity(0.08))

                        // Seller
                        sellerSection

                        // CTA buttons
                        ctaButtons
                            .padding(.bottom, 30)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(isPresented: $showCheckout) {
            CheckoutView(figure: figure)
                .environmentObject(store)
                .environmentObject(addressStore)
        }
        .sheet(isPresented: $showMessage) {
            MessagesView(sellerName: figure.seller.name)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive) {
                        showReportAlert = true
                    } label: {
                        Label("Report Product", systemImage: "exclamationmark.triangle")
                    }
                    
                    Button(role: .destructive) {
                        showBlockAlert = true
                    } label: {
                        Label("Block Seller", systemImage: "nosign")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.white)
                }
            }
        }
        .alert("Report Product", isPresented: $showReportAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Report", role: .destructive) {
                store.reportFigure(figure)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to report this product? Our team will review it within 24 hours.")
        }
        .alert("Block Seller", isPresented: $showBlockAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Block", role: .destructive) {
                store.blockSeller(figure.seller)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to block this seller? Their products will no longer appear in your feed.")
        }
    }

    // MARK: - Hero
    private var heroSection: some View {
        ZStack(alignment: .bottom) {
            // Real figure image
            Image(figure.systemImageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .clipped()

            // Gradient overlay for readability
            LinearGradient(
                colors: [.clear, Color(red: 0.07, green: 0.07, blue: 0.12).opacity(0.85)],
                startPoint: .top, endPoint: .bottom
            )
            .frame(height: 300)

            // Badges at bottom
            HStack(spacing: 8) {
                Text(figure.condition.rawValue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(figure.condition.color)
                    .cornerRadius(8)

                if figure.isFlashSale {
                    Label("Flash Sale", systemImage: "bolt.fill")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.yellow)
                        .cornerRadius(8)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 14)
        }
        .frame(height: 300)
    }

    // MARK: - Title
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(figure.series)
                .font(.caption)
                .foregroundColor(accentColor(figure.accentColorHex))
                .textCase(.uppercase)
                .tracking(1)
            Text(figure.name)
                .font(.title2)
                .fontWeight(.black)
                .foregroundColor(.white)
            HStack(alignment: .bottom, spacing: 10) {
                Text("$\(String(format: "%.2f", figure.price))")
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundColor(accentColor(figure.accentColorHex))
                if figure.discountPercent > 0 {
                    Text("$\(String(format: "%.2f", figure.originalPrice))")
                        .font(.subheadline)
                        .strikethrough()
                        .foregroundColor(.gray)
                    Text("-\(figure.discountPercent)%")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                }
                Spacer()
                Label("\(figure.stock) in stock", systemImage: "cube.box")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }

    // MARK: - Specs
    private var specsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Specifications")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                SpecCell(label: "Category", value: figure.category.rawValue)
                SpecCell(label: "Scale / Type", value: figure.scale)
                SpecCell(label: "Manufacturer", value: figure.manufacturer)
                SpecCell(label: "Character", value: figure.character)
            }
        }
    }

    // MARK: - Description
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(figure.description)
                .font(.body)
                .foregroundColor(.gray)
                .lineSpacing(4)
        }
    }

    // MARK: - Seller
    private var sellerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Seller")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)

            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(accentColor(figure.accentColorHex).opacity(0.3))
                        .frame(width: 46, height: 46)
                    Text(figure.seller.avatarInitial)
                        .font(.headline)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(figure.seller.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    HStack(spacing: 4) {
                        ForEach(0..<5) { i in
                            Image(systemName: i < Int(figure.seller.rating) ? "star.fill" : "star")
                                .font(.system(size: 10))
                                .foregroundColor(.yellow)
                        }
                        Text(String(format: "%.1f", figure.seller.rating))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "location.circle")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        Text(figure.seller.location)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("·")
                            .foregroundColor(.gray)
                        Text("\(figure.seller.totalSold) sold")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
            }
        }
    }

    // MARK: - CTA
    private var ctaButtons: some View {
        VStack(spacing: 12) {
            Button {
                showCheckout = true
            } label: {
                HStack {
                    Spacer()
                    Image(systemName: "bag.fill")
                    Text("Buy Now")
                        .fontWeight(.bold)
                    Spacer()
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 54)
                .background(
                    LinearGradient(colors: [Color(red: 0.42, green: 0.36, blue: 0.91), Color(red: 0.6, green: 0.1, blue: 0.8)],
                                   startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(16)
            }
            .disabled(figure.stock == 0)

//            Button {
//                showMessage = true
//            } label: {
//                HStack {
//                    Spacer()
//                    Image(systemName: "bubble.left.and.bubble.right")
//                    Text("Message Seller")
//                        .fontWeight(.semibold)
//                    Spacer()
//                }
//                .font(.subheadline)
//                .foregroundColor(.white)
//                .frame(height: 54)
//                .background(Color.white.opacity(0.08))
//                .cornerRadius(16)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 16)
//                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
//                )
//            }
        }
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

// MARK: - SpecCell

struct SpecCell: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption2)
                .foregroundColor(.gray)
                .textCase(.uppercase)
                .tracking(0.5)
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
    }
}
