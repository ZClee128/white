import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Modern Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search premium VR headers", text: $searchText)
                    }
                    .padding(14)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Premium Exposure Module to Stimulate Consumption
                    FeaturedCarouselView(products: appState.products.filter { $0.isFeatured })
                    
                    // Equipment Listing
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Top Rated Gear")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                            ForEach(appState.products) { product in
                                NavigationLink(destination: ProductDetailView(product: product)) {
                                    ProductCardView(product: product)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Discover")
        }
    }
}

struct FeaturedCarouselView: View {
    var products: [Product]
    
    var body: some View {
        TabView {
            ForEach(products) { product in
                NavigationLink(destination: ProductDetailView(product: product)) {
                    ZStack(alignment: .bottomLeading) {
                        AsyncImage(url: URL(string: product.imageURL)) { image in
                            image.resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        // Gradient Overlay
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.8), Color.clear]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("FEATURED")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue)
                                .cornerRadius(8)
                            
                            Text(product.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Rent from $\(String(format: "%.2f", product.pricePerDay))/day")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                }
            }
        }
        .frame(height: 220)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
}

struct ProductCardView: View {
    var product: Product
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: product.imageURL)) { image in
                image.resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(height: 140)
            .clipped()
            
            VStack(alignment: .leading, spacing: 6) {
                Text(product.brand.uppercased())
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                Text(product.name)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 12))
                    Text(String(format: "%.1f", product.rating))
                        .font(.caption)
                        .fontWeight(.medium)
                }
                
                Text("$\(String(format: "%.2f", product.pricePerDay)) / day")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .padding(12)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}
