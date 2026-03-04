import SwiftUI

struct CartView: View {
    @EnvironmentObject var appState: AppState
    
    var totalPrice: Double {
        appState.cart.reduce(0) { $0 + $1.pricePerDay }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all)
                
                if appState.cart.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "cart")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Your cart is empty")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                } else {
                    VStack {
                        List {
                            ForEach(appState.cart) { product in
                                CartRowView(product: product)
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .listStyle(InsetGroupedListStyle())
                        
                        VStack(spacing: 20) {
                            HStack {
                                Text("Total Estimated Daily:")
                                    .font(.headline)
                                Spacer()
                                Text("$\(String(format: "%.2f", totalPrice))")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                            
                            NavigationLink(destination: CheckoutView()) {
                                Text("Proceed to Checkout")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(16)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.05), radius: 10, y: -5)
                    }
                }
            }
            .navigationTitle("Cart")
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        appState.cart.remove(atOffsets: offsets)
    }
}

struct CartRowView: View {
    var product: Product
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: product.imageURL)) { image in
                image.resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 80, height: 80)
            .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(product.name)
                    .font(.headline)
                Text(product.brand)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("$\(String(format: "%.2f", product.pricePerDay)) / day")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
