import SwiftUI

struct AddressEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var addressManager: AddressManager
    
    // Original address if editing, nil if adding new
    var addressToEdit: Address?
    
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    @State private var region: String = ""
    @State private var detailAddress: String = ""
    @State private var isDefault: Bool = false
    
    // Validation
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Contact Information")) {
                    TextField("Full Name", text: $name)
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Address Details")) {
                    TextField("State/City/Region", text: $region)
                    TextField("Detailed Address (Street, Bldg, Apt)", text: $detailAddress)
                }
                
                Section {
                    Toggle("Set as Default Address", isOn: $isDefault)
                }
            }
            .navigationTitle(addressToEdit == nil ? "New Address" : "Edit Address")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveAddress()
                    }
                    .font(.headline)
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Missing Information"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                if let existing = addressToEdit {
                    name = existing.name
                    phoneNumber = existing.phoneNumber
                    region = existing.region
                    detailAddress = existing.detailAddress
                    isDefault = existing.isDefault
                }
            }
        }
    }
    
    private func saveAddress() {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty,
              !region.trimmingCharacters(in: .whitespaces).isEmpty,
              !detailAddress.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Please fill in all the required fields."
            showingAlert = true
            return
        }
        
        var newAddress = addressToEdit ?? Address(name: name, phoneNumber: phoneNumber, region: region, detailAddress: detailAddress, isDefault: isDefault)
        
        // Always assign the latest text fields
        newAddress.name = name
        newAddress.phoneNumber = phoneNumber
        newAddress.region = region
        newAddress.detailAddress = detailAddress
        newAddress.isDefault = isDefault
        
        if addressToEdit != nil {
            addressManager.updateAddress(newAddress)
        } else {
            addressManager.addAddress(newAddress)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddressEditView()
        .environmentObject(AddressManager())
}
