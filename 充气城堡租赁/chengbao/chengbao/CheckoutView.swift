import SwiftUI
import UIKit

struct CheckoutView: View {
    let castle: BouncyCastle
    let address: Address
    let rentalDays: Int
    @Binding var goHome: Bool
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataStore: DataStore
    
    @State private var showingSuccess = false
    @State private var isProcessing = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Context Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Checkout")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Image(systemName: "arrow.left").opacity(0)
            }
            .padding()
            .background(Color.white)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Order Summary
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Order Summary")
                            .font(.system(size: 18, weight: .bold))
                        
                        HStack(alignment: .top) {
                            Image(castle.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(castle.name)
                                    .font(.system(size: 16, weight: .bold))
                                Text("\(rentalDays) \(rentalDays == 1 ? "Day" : "Days") Rental")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("$\(String(format: "%.0f", castle.pricePerDay * Double(rentalDays)))")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    // Shipping Address
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Shipping To")
                            .font(.system(size: 18, weight: .bold))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(address.fullName)
                                .font(.system(size: 16, weight: .medium))
                            Text(address.phoneNumber)
                                .foregroundColor(.gray)
                            Text("\(address.streetAddress), \(address.city), \(address.state) \(address.zipCode)")
                                .foregroundColor(.gray)
                        }
                        .font(.system(size: 14))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    // Total
                    HStack {
                        Text("Total Amount")
                            .font(.system(size: 18, weight: .bold))
                        Spacer()
                        Text("$\(String(format: "%.0f", castle.pricePerDay * Double(rentalDays)))")
                            .font(.system(size: 24, weight: .black))
                    }
                    .padding()
                }
                .padding(24)
            }
            
            // Cash on Delivery Button
            VStack {
                Divider()
                Button(action: {
                    processPayment()
                }) {
                    HStack {
                        Image(systemName: "banknote.fill")
                        Text("Place Order (Cash on Delivery)")
                    }
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(25)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 36)
            }
            .background(Color.white)
            
            // Invisible NavigationLink to avoid 4.3 simple push
            NavigationLink(destination: OrderSuccessView(goHome: $goHome), isActive: $showingSuccess) {
                EmptyView()
            }
        }
        .navigationBarHidden(true)
        .background(Color(hex: "#FAFAFA").edgesIgnoringSafeArea(.all))
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Pending Payment"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    goHome = false // Return to home screen
                }
            )
        }
    }
    
    private func processPayment() {
        createOrder(status: .pending)
        showingSuccess = true
    }
    
    private func createOrder(status: OrderStatus) {
        let total = castle.pricePerDay * Double(rentalDays)
        let newOrder = Order(id: UUID(), bouncyCastleId: castle.id, address: address, totalAmount: total, orderDate: Date(), status: status, wechatTransactionId: nil)
        dataStore.saveOrder(newOrder)
    }
}
