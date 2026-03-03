import SwiftUI

struct AddressEditView: View {
    @EnvironmentObject var addressManager: AddressManager
    @Environment(\.presentationMode) var presentationMode
    
    var existingAddress: Address?
    
    @State private var fullName = ""
    @State private var phoneNumber = ""
    @State private var streetAddress = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""
    @State private var isDefault = false
    
    init(address: Address?) {
        self.existingAddress = address
        if let addr = address {
            _fullName = State(initialValue: addr.fullName)
            _phoneNumber = State(initialValue: addr.phoneNumber)
            _streetAddress = State(initialValue: addr.streetAddress)
            _city = State(initialValue: addr.city)
            _state = State(initialValue: addr.state)
            _zipCode = State(initialValue: addr.zipCode)
            _isDefault = State(initialValue: addr.isDefault)
        }
    }
    
    var isFormValid: Bool {
        !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !state.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !zipCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        Form {
            Section(header: Text("Contact Info")) {
                TextField("Full Name", text: $fullName)
                TextField("Phone Number", text: $phoneNumber)
                    .keyboardType(.phonePad)
            }
            
            Section(header: Text("Address")) {
                TextField("Street Address", text: $streetAddress)
                TextField("City", text: $city)
                HStack {
                    TextField("State / Province", text: $state)
                    Divider()
                    TextField("ZIP / Postal Code", text: $zipCode)
                }
            }
            
            Section {
                Toggle("Set as Default Shipping Address", isOn: $isDefault)
            }
        }
        .navigationTitle(existingAddress == nil ? "New Address" : "Edit Address")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveAddress()
                }
                .disabled(!isFormValid)
            }
        }
    }
    
    private func saveAddress() {
        if var address = existingAddress {
            address.fullName = fullName
            address.phoneNumber = phoneNumber
            address.streetAddress = streetAddress
            address.city = city
            address.state = state
            address.zipCode = zipCode
            address.isDefault = isDefault
            addressManager.updateAddress(address)
        } else {
            let address = Address(fullName: fullName, phoneNumber: phoneNumber, streetAddress: streetAddress, city: city, state: state, zipCode: zipCode, isDefault: isDefault)
            addressManager.addAddress(address)
        }
        presentationMode.wrappedValue.dismiss()
    }
}
