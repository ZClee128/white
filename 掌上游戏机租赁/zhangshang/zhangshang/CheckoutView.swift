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
                                Text("$\(String(format: "%.1f", priceToUse))/day")
                                    .font(.subheadline)
                                    .foregroundColor(discountedPrice != nil ? .red : .secondary)
                                
                                if discountedPrice != nil {
                                    Text("$\(String(format: "%.0f", console.dailyPrice))")
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
                        Text("$\(String(format: "%.1f", priceToUse * Double(rentalDays)))")
                    }
                    
                    HStack {
                        Text("Device Deposit (Refundable)")
                        Spacer()
                        Text("$\(String(format: "%.0f", console.deposit))")
                    }
                    
                    HStack {
                        Text("Total Amount")
                            .font(.headline)
                        Spacer()
                        Text("$\(String(format: "%.0f", totalPrice))")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    Button(action: processCashOnDelivery) {
                        HStack {
                            Spacer()
                            if isProcessingPayment {
                                ProgressView()
                            } else {
                                Image(systemName: "banknote.fill")
                                    .foregroundColor(.white)
                                Text("Cash on Delivery")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.blue)
                    .disabled(isProcessingPayment)
                } footer: {
                    Text("Payment will be collected upon delivery. Deposit will be refunded upon device return.")
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
    
    private func processCashOnDelivery() {
        guard selectedAddress != nil else {
            alertMessage = "Please select a shipping address before completing your order."
            showingAlert = true
            return
        }
        
        isProcessingPayment = true
        
        // Simulate order processing time
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.alertMessage = "Order placed successfully! Please prepare cash for delivery."
            self.showingAlert = true
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
