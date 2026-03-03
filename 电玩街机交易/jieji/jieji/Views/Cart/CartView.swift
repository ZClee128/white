import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        NavigationView {
            VStack {
                if cartManager.items.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "cart.badge.minus")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        Text("Your cart is empty")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(cartManager.items) { item in
                                CartItemView(item: item)
                            }
                        }
                        .padding()
                    }
                    
                    VStack {
                        HStack {
                            Text("Total:")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            Text(String(format: "$%.2f", cartManager.totalPrice))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.accentColor)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        NavigationLink(destination: CheckoutView()) {
                            Text("Proceed to Checkout")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .cornerRadius(16)
                                .shadow(color: Color.accentColor.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .padding()
                    }
                    .background(Color(.systemBackground).shadow(radius: 2, y: -2))
                }
            }
            .navigationTitle("Cart")
        }
    }
}

struct CartItemView: View {
    let item: OrderItem
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        HStack(spacing: 16) {
            Image(item.machine.name)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(item.machine.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(String(format: "$%.2f", item.machine.price))
                    .font(.subheadline)
                    .foregroundColor(.accentColor)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    cartManager.removeFromCart(machine: item.machine)
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title3)
                }
                
                Text("\(item.quantity)")
                    .font(.headline)
                    .frame(width: 30)
                
                Button(action: {
                    cartManager.addToCart(machine: item.machine)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.accentColor)
                        .font(.title3)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}
