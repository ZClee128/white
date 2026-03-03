import SwiftUI

struct CheckoutView: View {
    let console: Console
    var discountedPrice: Double? = nil
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var orderManager: OrderManager
    @EnvironmentObject var addressManager: AddressManager
    
    @State private var rentalDays: Int = 3
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isProcessingPayment = false
    
    // Address Selection State
    @State private var selectedAddress: Address?
    @State private var showingAddressList = false
    
    var priceToUse: Double {
        discountedPrice ?? console.dailyPrice
    }
    
    var totalPrice: Double {
        (priceToUse * Double(rentalDays)) + console.deposit
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Shipping Address")) {
                    if let address = selectedAddress {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(address.name)
                                        .font(.headline)
                                    Text(address.phoneNumber)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Text(address.fullAddress)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button(action: {
                                showingAddressList = true
                            }) {
                                Text("Change")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                    } else {
                        Button(action: {
                            showingAddressList = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.purple)
                                Text("Add Shipping Address")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                Section(header: Text("Device Information")) {
                    HStack {
                        Image(console.name)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 45)
                        
                        VStack(alignment: .leading) {
                            Text(console.name)
                                .font(.headline)
                            HStack(spacing: 4) {
                                Text("¥\(String(format: "%.1f", priceToUse))/day")
                                    .font(.subheadline)
                                    .foregroundColor(discountedPrice != nil ? .red : .secondary)
                                
                                if discountedPrice != nil {
                                    Text("¥\(String(format: "%.0f", console.dailyPrice))")
                                        .font(.caption2)
                                        .strikethrough()
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
                
                Section(header: Text("Rental Duration")) {
                    Stepper(value: $rentalDays, in: 1...30) {
                        Text("\(rentalDays) Days")
                            .font(.headline)
                    }
                }
                
                Section(header: Text("Payment Summary")) {
                    HStack {
                        Text("Rental Fee (\(rentalDays) days)")
                        Spacer()
                        Text("¥\(String(format: "%.1f", priceToUse * Double(rentalDays)))")
                    }
                    
                    HStack {
                        Text("Device Deposit (Refundable)")
                        Spacer()
                        Text("¥\(String(format: "%.0f", console.deposit))")
                    }
                    
                    HStack {
                        Text("Total Amount")
                            .font(.headline)
                        Spacer()
                        Text("¥\(String(format: "%.0f", totalPrice))")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    Button(action: processWeChatPay) {
                        HStack {
                            Spacer()
                            if isProcessingPayment {
                                ProgressView()
                            } else {
                                Image(systemName: "message.fill") // Using standard icon as WeChat placeholder
                                    .foregroundColor(.white)
                                Text("Pay with WeChat")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.green)
                    .disabled(isProcessingPayment)
                } footer: {
                    Text("WeChat Pay is required for this transaction. Deposit will be refunded upon device return.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                }
            }
            .navigationTitle("Checkout")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
            .alert("Payment Info", isPresented: $showingAlert) {
                Button("OK", role: .cancel) {
                    if isProcessingPayment {
                        finalizeOrder()
                    }
                }
            } message: {
                Text(alertMessage)
            }
            .onAppear {
                // Initialize default address if none selected
                if selectedAddress == nil {
                    selectedAddress = addressManager.defaultOrFirstAddress
                }
            }
            .sheet(isPresented: $showingAddressList) {
                AddressListView(selectedAddress: $selectedAddress, isSelectionMode: true)
                    .environmentObject(addressManager)
            }
        }
    }
    
    private func processWeChatPay() {
        guard selectedAddress != nil else {
            alertMessage = "Please select a shipping address before completing your order."
            showingAlert = true
            return
        }
        
        // App Store 4.3 & WeChat logic Check
        guard let wechatUrl = URL(string: "weixin://") else { return }
        
        // This checks if the scheme can be opened
        if UIApplication.shared.canOpenURL(wechatUrl) {
            isProcessingPayment = true
            
            // Simulate payment processing time
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // In a real app, you would use WeChat SDK to open WeChat and await a callback
                // Here we simulate successful payment for the closed loop demo
                self.alertMessage = "Payment successful! Your order has been placed."
                self.showingAlert = true
            }
        } else {
            // WeChat is not installed or scheme is not whitelisted in Info.plist
            alertMessage = "Please install WeChat to proceed with the payment."
            showingAlert = true
        }
    }
    
    private func finalizeOrder() {
        orderManager.createOrder(console: console, days: rentalDays, activePrice: discountedPrice)
        isProcessingPayment = false
        dismiss()
    }
}

#Preview {
    Text("Checkout Preview")
        .sheet(isPresented: .constant(true)) {
            let manager = AddressManager()
            // Add a mock address for preview purposes
            manager.addAddress(Address(name: "John Doe", phoneNumber: "123456789", region: "NY", detailAddress: "123 Apple St", isDefault: true))
            
            return CheckoutView(console: MockData.consoles[0])
                .environmentObject(OrderManager())
                .environmentObject(manager)
        }
}
