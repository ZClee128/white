import SwiftUI

struct PackageBundle: Identifiable {
    var id: UUID = UUID()
    var name: String
    var description: String
    var pricePerDay: Double
    var regularPricePerDay: Double
    var imageName: String
    var itemsIncluded: [String]
    var isPopular: Bool = false
}

struct PackagesView: View {
    @EnvironmentObject var appState: AppState
    
    let packages: [PackageBundle] = [
        PackageBundle(name: "Ultimate Cinema Set", description: "Immerse yourself in 4K HDR movies. Includes Apple Vision Pro, AirPods Max, and a premium travel case.", pricePerDay: 59.99, regularPricePerDay: 75.00, imageName: "Vision Pro", itemsIncluded: ["Apple Vision Pro", "AirPods Max", "Travel Case", "Lens Cleaning Kit"], isPopular: true),
        PackageBundle(name: "Weekend Gamer Pack", description: "Everything you need for an unforgettable weekend with friends. Meta Quest 3 plus an extra battery strap.", pricePerDay: 24.99, regularPricePerDay: 35.00, imageName: "Quest 3", itemsIncluded: ["Meta Quest 3", "Elite Strap with Battery", "Protective Carrying Case"], isPopular: true),
        PackageBundle(name: "Hardcore Sim Racer", description: "The ultimate visual fidelity for flight and racing sims. PC required.", pricePerDay: 65.99, regularPricePerDay: 85.00, imageName: "Valve Index", itemsIncluded: ["Varjo Aero OR Valve Index", "Base Stations x2", "High-Speed Link Cable"], isPopular: false),
        PackageBundle(name: "Family Party Bundle", description: "Two headsets so the fun never stops. Perfect for multiplayer games at home.", pricePerDay: 28.99, regularPricePerDay: 40.00, imageName: "Quest 2", itemsIncluded: ["Meta Quest 2 x2", "Silicone Face Covers x4", "Chromecast for TV Casting"], isPopular: false)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header text
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Rental Packages")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Save more when you rent bundles")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Package Cards
                    ForEach(packages) { package in
                        NavigationLink(destination: PackageDetailView(package: package)) {
                            PackageCard(package: package)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 30)
            }
            .navigationBarHidden(true)
        }
    }
}

struct PackageCard: View {
    var package: PackageBundle
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Image(package.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                .frame(height: 180)
                .clipped()
                
                if package.isPopular {
                    Text("MOST POPULAR")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        .padding(12)
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(package.name)
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("$\(String(format: "%.2f", package.pricePerDay))/day")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        Text("$\(String(format: "%.2f", package.regularPricePerDay))")
                            .font(.caption)
                            .strikethrough()
                            .foregroundColor(.gray)
                    }
                }
                
                Text(package.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack(spacing: 6) {
                    ForEach(package.itemsIncluded.prefix(2), id: \.self) { item in
                        Text(item)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.15))
                            .cornerRadius(4)
                    }
                    if package.itemsIncluded.count > 2 {
                        Text("+\(package.itemsIncluded.count - 2) more")
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.15))
                            .cornerRadius(4)
                    }
                }
            }
            .padding(16)
            .background(Color(.systemBackground))
        }
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
    }
}

struct PackageDetailView: View {
    var package: PackageBundle
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    @State private var showingToast = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header Image
                ZStack(alignment: .topLeading) {
                    Image(package.imageName)
                        .resizable()
                        .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 350)
                    .clipped()
                }
                
                // Content
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            if package.isPopular {
                                Text("POPULAR BUNDLE")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.orange)
                            } else {
                                Text("BUNDLE OFFER")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                            }
                            
                            Text(package.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        Spacer()
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Bundle Price")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("$\(String(format: "%.2f", package.pricePerDay)) / day")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Regular Price")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("$\(String(format: "%.2f", package.regularPricePerDay))")
                                .font(.headline)
                                .strikethrough()
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(12)
                    
                    Divider()
                    
                    Text("Description")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(package.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                    
                    Divider()
                    
                    Text("What's Included")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(package.itemsIncluded, id: \.self) { item in
                            HStack {
                                Image(systemName: "cube.box.fill")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 20))
                                    .frame(width: 30)
                                Text(item)
                                    .font(.body)
                            }
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(30)
                .offset(y: -30)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
        .overlay(
            VStack {
                Spacer()
                Button(action: {
                    // Create a dummy product to add to cart representing the bundle
                    let bundleProduct = Product(
                        name: package.name,
                        brand: "Bundle",
                        pricePerDay: package.pricePerDay,
                        originalPrice: package.regularPricePerDay * 50,
                        description: package.description,
                        imageURL: package.imageName,
                        specifications: package.itemsIncluded
                    )
                    appState.cart.append(bundleProduct)
                    showingToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showingToast = false
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Add Bundle to Cart")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(16)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
            }
        )
        .overlay(
            Group {
                if showingToast {
                    VStack {
                        Text("Bundle Added to Cart")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(20)
                            .padding(.top, 50)
                        Spacer()
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.easeInOut, value: showingToast)
                    .zIndex(1)
                }
            }
        )
    }
}
