import SwiftUI

struct CartView: View {
    @EnvironmentObject var store: StoreData
    
    var body: some View {
        NavigationView {
            Group {
                if store.cart.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "cart.badge.minus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                        
                        Text("Cart is empty")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        ForEach(store.cart) { item in
                            HStack {
                                Image(item.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                                    .clipped()
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(item.name)
                                        .font(.headline)
                                    
                                    Text(item.playName)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Text(String(format: "¥%.2f", item.price))
                                    .fontWeight(.bold)
                            }
                            .padding(.vertical, 5)
                        }
                        .onDelete(perform: store.removeFromCart)
                    }
                }
            }
            .navigationTitle("Cart")
            .safeAreaInset(edge: .bottom) {
                if !store.cart.isEmpty {
                    VStack {
                        Divider()
                        HStack {
                            Text("Total:")
                                .font(.title3)
                            Text(String(format: "¥%.2f", store.cartTotal))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                            
                            Spacer()
                            
                            NavigationLink(destination: CheckoutView()) {
                                Text("Checkout")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 12)
                                    .background(Color.red)
                                    .cornerRadius(20)
                            }
                        }
                        .padding()
                    }
                    .background(.ultraThinMaterial)
                }
            }
        }
    }
}

#Preview {
    CartView()
        .environmentObject(StoreData())
}
