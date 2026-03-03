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
            
            // WeChat Pay Button
            VStack {
                Divider()
                Button(action: {
                    processPayment()
                }) {
                    HStack {
                        Image(systemName: "message.fill") // Placeholder for WeChat icon
                        Text("Pay with WeChat")
                    }
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(hex: "#07C160")) // Official wechat green
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
        let wechatScheme = "weixin://"
        guard let url = URL(string: wechatScheme) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            // Wechat is installed, we can attempt to open it.
            // In a real app we'd use the WeChat SDK. Here we simulate completing the order.
            createOrder(status: .confirmed)
            showingSuccess = true
        } else {
            // Wechat is not installed.
            // Save as pending payment and notify user.
            createOrder(status: .pending)
            alertMessage = "WeChat is not installed. Your order has been saved as a Pending Payment. You can view it in My Rentals."
            showAlert = true
        }
    }
    
    private func createOrder(status: OrderStatus) {
        let total = castle.pricePerDay * Double(rentalDays)
        let newOrder = Order(id: UUID(), bouncyCastleId: castle.id, address: address, totalAmount: total, orderDate: Date(), status: status, wechatTransactionId: status == .confirmed ? "WX\(Int.random(in: 1000...9999))" : nil)
        dataStore.saveOrder(newOrder)
    }
}
