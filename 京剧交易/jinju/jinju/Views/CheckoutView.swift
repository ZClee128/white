import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var store: StoreData
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedAddress: Address?
    @State private var selectedPaymentMethod: String = "WeChat"
    @State private var isPaying = false
    @State private var showSuccessAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Shipping Information")) {
                if let address = selectedAddress {
                    NavigationLink(destination: AddressListView(selectedAddress: $selectedAddress, isSelectionMode: true)) {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(address.name)
                                    .font(.headline)
                                Text(address.phone)
                                    .foregroundColor(.secondary)
                            }
                            Text(address.detail)
                                .font(.body)
                        }
                    }
                } else {
                    NavigationLink(destination: AddressListView(selectedAddress: $selectedAddress, isSelectionMode: true)) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                            Text("Select Shipping Address")
                                .foregroundColor(.blue)
                        }
                    }
                }
        }
        
        Section(header: Text("Order Items")) {
            ForEach(store.cart) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text(String(format: "¥%.2f", item.price))
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                Text("Shipping Fee")
                Spacer()
                Text("¥0.00")
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("Total")
                    .fontWeight(.bold)
                Spacer()
                Text(String(format: "¥%.2f", store.cartTotal))
                    .fontWeight(.bold)
                    .foregroundColor(.red)
            }
        }
        
        Section(header: Text("Payment Method")) {
            Button(action: { }) {
                HStack {
                    Image(systemName: "w.circle.fill")
                        .foregroundColor(.green)
                    Text("WeChat Pay")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
        }
        
        Section {
            Button(action: simulatePayment) {
                HStack {
                    Spacer()
                    if isPaying {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text("Confirm Payment ¥\(String(format: "%.2f", store.cartTotal))")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
            }
            .disabled(selectedAddress == nil || isPaying)
            .listRowBackground(selectedAddress == nil ? Color.gray.opacity(0.3) : Color.blue)
        }
    }
    .navigationTitle("Confirm Order")
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
        if selectedAddress == nil {
            selectedAddress = store.addresses.first(where: { $0.isDefault }) ?? store.addresses.first
        }
    }
    .alert("WeChat Not Installed", isPresented: $showWeChatAlert) {
        Button("Back", role: .cancel) { }
    } message: {
        Text("Secure payment requires WeChat. Please install WeChat from the App Store and try again.")
    }
}

@State private var showWeChatAlert = false

private func simulatePayment() {
    guard selectedAddress != nil else { return }
    
    isPaying = true
    // Simulate network delay to verify risk/status
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
        self.isPaying = false
        self.showWeChatAlert = true
    }
}
}

#Preview {
    NavigationView {
        CheckoutView()
            .environmentObject(StoreData())
    }
}
