import SwiftUI

struct ProductDetailView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    var product: Product
    
    @State private var showingToast = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header Image
                ZStack(alignment: .topLeading) {
                    Image(product.name)
                        .resizable()
                        .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 350)
                    .clipped()
                }
                
                // Content
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.brand.uppercased())
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            
                            Text(product.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("$\(String(format: "%.2f", product.pricePerDay))")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            Text("per day")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(String(format: "%.1f", product.rating)) (\(product.reviewsCount) reviews)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    Text("Description")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(product.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                    
                    Divider()
                    
                    Text("Specifications")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(product.specifications, id: \.self) { spec in
                            HStack(alignment: .top) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                                Text(spec)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
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
                    appState.cart.append(product)
                    showingToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showingToast = false
                    }
                }) {
                    Text("Add to Cart")
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
            toastView()
        )
    }
    
    @ViewBuilder
    private func toastView() -> some View {
        if showingToast {
            VStack {
                Text("Added to Cart Successfully")
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
}


