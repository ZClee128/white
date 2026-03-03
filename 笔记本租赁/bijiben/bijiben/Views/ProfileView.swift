import SwiftUI

struct ProfileView: View {
    @Environment(RentalStore.self) var store
    @State private var showContactInfo = false
    
    // Using AppStorage to show what they've saved in the rental form
    @AppStorage("savedContactName") private var savedName = ""
    @AppStorage("savedContactPhone") private var savedPhone = ""
    @AppStorage("savedDeliveryAddress") private var savedAddress = ""

    @State private var showEditName = false
    @State private var editNameText = ""
    
    @State private var showEditPhone = false
    @State private var editPhoneText = ""
    
    @State private var showEditAddress = false
    @State private var editAddressText = ""

    var body: some View {
        NavigationStack {
            List {
                // Content
                Section("My Rentals") {
                    NavigationLink(destination: MyOrdersView()) {
                        Label("Order History", systemImage: "clock.arrow.circlepath")
                    }
                }
                
                // Details
                Section("Saved Information") {
                    Button {
                        editNameText = savedName
                        showEditName = true
                    } label: {
                        HStack {
                            Label("Contact Name", systemImage: "person.fill")
                                .foregroundColor(.primary)
                            Spacer()
                            Text(savedName.isEmpty ? "Not set" : savedName)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    Button {
                        editPhoneText = savedPhone
                        showEditPhone = true
                    } label: {
                        HStack {
                            Label("Phone Number", systemImage: "phone.fill")
                                .foregroundColor(.primary)
                            Spacer()
                            Text(savedPhone.isEmpty ? "Not set" : savedPhone)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    Button {
                        editAddressText = savedAddress
                        showEditAddress = true
                    } label: {
                        HStack {
                            Label("Delivery Address", systemImage: "location.fill")
                                .foregroundColor(.primary)
                            Spacer()
                            Text(savedAddress.isEmpty ? "Not set" : savedAddress)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .frame(maxWidth: 120, alignment: .trailing)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Support & Legal
                Section("Support") {
                    Button {
                        showContactInfo = true
                    } label: {
                        Label("Contact Support", systemImage: "headphones")
                            .foregroundColor(.primary)
                    }
                    
                    Link(destination: URL(string: "https://www.apple.com/legal/privacy/")!) {
                        Label("Privacy Policy", systemImage: "hand.raised.fill")
                            .foregroundColor(.primary)
                    }
                    
                    Link(destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!) {
                        Label("Terms of Service", systemImage: "doc.text.fill")
                            .foregroundColor(.primary)
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 6) {
                            Text("LaptopRentals")
                                .font(.subheadline.bold())
                                .foregroundColor(.secondary)
                            Text("Version 1.0.0")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Settings")
            // Alerts for editing
            .alert("Edit Contact Name", isPresented: $showEditName) {
                TextField("Name", text: $editNameText)
                Button("Cancel", role: .cancel) { }
                Button("Save") { savedName = editNameText }
            } message: { Text("This will be auto-filled in future rentals.") }
            .alert("Edit Phone Number", isPresented: $showEditPhone) {
                TextField("Phone", text: $editPhoneText)
                    .keyboardType(.phonePad)
                Button("Cancel", role: .cancel) { }
                Button("Save") { savedPhone = editPhoneText }
            } message: { Text("This will be auto-filled in future rentals.") }
            .alert("Edit Delivery Address", isPresented: $showEditAddress) {
                TextField("Address", text: $editAddressText)
                Button("Cancel", role: .cancel) { }
                Button("Save") { savedAddress = editAddressText }
            } message: { Text("This will be auto-filled in future rentals.") }
            // General support alert
            .alert("Support", isPresented: $showContactInfo) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("For rental extensions, early returns, or technical support, please contact us via WeChat: laptop_rentals_cs")
            }
        }
    }
}

#Preview {
    ProfileView()
        .environment(RentalStore())
}
