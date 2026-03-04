import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var addressManager: AddressManager
    @EnvironmentObject var orderManager: OrderManager
    
    @State private var navigateToSuccess = false
    
    var defaultAddress: Address? {
        addressManager.addresses.first(where: { $0.isDefault }) ?? addressManager.addresses.first
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Address Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Shipping Address")
                        .font(.headline)
                    
                    if let address = defaultAddress {
                        NavigationLink(destination: AddressListView()) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(address.fullName)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                    Text("\(address.streetAddress), \(address.city), \(address.state) \(address.zipCode)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(address.phoneNumber)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                    } else {
                        NavigationLink(destination: AddressEditView(address: nil)) {
                            HStack {
                                Image(systemName: "plus.circle")
                                Text("Add Shipping Address")
                                Spacer()
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Order Summary
                VStack(alignment: .leading, spacing: 12) {
                    Text("Order Summary")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        ForEach(cartManager.items) { item in
                            HStack {
                                Text("\(item.quantity)x \(item.machine.name)")
                                    .font(.subheadline)
                                    .lineLimit(1)
                                Spacer()
                                Text(String(format: "$%.2f", item.machine.price * Double(item.quantity)))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("Total")
                                .font(.headline)
                            Spacer()
                            Text(String(format: "$%.2f", cartManager.totalPrice))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.accentColor)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // WeChat Pay Button
                Button(action: submitOrderAction) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill") 
                            .foregroundColor(.white)
                        Text("Submit Order")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor) 
                    .cornerRadius(16)
                    .shadow(color: Color.accentColor.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .disabled(defaultAddress == nil || cartManager.items.isEmpty)
                .opacity((defaultAddress == nil || cartManager.items.isEmpty) ? 0.5 : 1.0)
                
                NavigationLink(destination: OrderSuccessView(), isActive: $navigateToSuccess) {
                    EmptyView()
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Checkout")
        .navigationTitle("Checkout")
    }
    
    private func submitOrderAction() {
        guard let address = defaultAddress else { return }
        
        // Create Order as Cash on Delivery and clear cart
        let orderId = orderManager.createOrder(items: cartManager.items, totalAmount: cartManager.totalPrice, address: address, status: "Cash on Delivery")
        cartManager.clearCart()
        
        navigateToSuccess = true
    }
}
