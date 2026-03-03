import SwiftUI

struct AddressListView: View {
    @EnvironmentObject var store: StoreData
    @Binding var selectedAddress: Address?
    @Environment(\.presentationMode) var presentationMode
    
    var isSelectionMode: Bool
    
    var body: some View {
        List {
            ForEach(store.addresses) { address in
                Button(action: {
                    if isSelectionMode {
                        selectedAddress = address
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(address.name)
                                    .font(.headline)
                                Text(address.phone)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                if address.isDefault {
                                    Text("Default")
                                        .font(.caption)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.red.opacity(0.1))
                                        .foregroundColor(.red)
                                        .cornerRadius(4)
                                }
                            }
                            
                            Text(address.detail)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        if isSelectionMode && selectedAddress?.id == address.id {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .navigationTitle("Shipping Address")
        .navigationBarItems(trailing: NavigationLink(destination: AddAddressView()) {
            Image(systemName: "plus")
        })
    }
}

struct AddAddressView: View {
    @EnvironmentObject var store: StoreData
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var detail: String = ""
    @State private var isDefault: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("Contact Info")) {
                TextField("Name", text: $name)
                TextField("Phone Number", text: $phone)
                    .keyboardType(.phonePad)
            }
            
            Section(header: Text("Address Info")) {
                TextField("Detailed address (e.g., street, floor, apt.)", text: $detail)
            }
            
            Section {
                Toggle("Set as default address", isOn: $isDefault)
            }
            
            Section {
                Button(action: saveAddress) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.blue)
                }
                .disabled(name.isEmpty || phone.isEmpty || detail.isEmpty)
            }
        }
        .navigationTitle("Add Address")
    }
    
    private func saveAddress() {
        let newAddress = Address(name: name, phone: phone, detail: detail, isDefault: isDefault)
        store.addAddress(newAddress)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    NavigationView {
        AddressListView(selectedAddress: .constant(nil), isSelectionMode: false)
            .environmentObject(StoreData())
    }
}
