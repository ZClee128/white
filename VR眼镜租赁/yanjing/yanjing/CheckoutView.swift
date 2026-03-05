import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isProcessing = false
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "creditcard.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
                .padding(.top, 40)
            
            Text("Complete Your Order")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(spacing: 8) {
                Text("Total Amount Due")
                    .foregroundColor(.secondary)
                Text("$\(String(format: "%.2f", appState.cart.reduce(0) { $0 + $1.pricePerDay }))")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
            
            Spacer()
            
            Button(action: {
                processCheckout()
            }) {
                if isProcessing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    HStack {
                        Image(systemName: "box.truck.fill")
                        Text("Place Order (Cash on Delivery)")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(16)
            .disabled(isProcessing)
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            .padding(.bottom, 20)
        }
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Order Confirmed"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    for product in appState.cart {
                        let newOrder = Order(orderNumber: UUID().uuidString.prefix(8).uppercased(), product: product, rentalDays: 1, status: .cashOnDelivery, totalAmount: product.pricePerDay, date: Date())
                        appState.orders.append(newOrder)
                    }
                    appState.cart.removeAll()
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    func processCheckout() {
        isProcessing = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isProcessing = false
            self.alertMessage = "Your order has been placed successfully! Please pay the courier in cash when your VR equipment is delivered."
            self.showingAlert = true
        }
    }
}
