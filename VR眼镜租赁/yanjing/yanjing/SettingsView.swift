import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingPrivacyPolicy = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account & Setup")) {
                    NavigationLink(destination: AddressManagementView()) {
                        HStack {
                            Image(systemName: "map.fill")
                                .foregroundColor(.blue)
                                .frame(width: 30)
                            Text("Delivery Address")
                        }
                    }
                    
                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(.purple)
                            .frame(width: 30)
                        Text("Language")
                        Spacer()
                        Text("English")
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("Legal & Support")) {
                    Button(action: { showingPrivacyPolicy = true }) {
                        HStack {
                            Image(systemName: "hand.raised.fill")
                                .foregroundColor(.green)
                                .frame(width: 30)
                            Text("Privacy Policy")
                                .foregroundColor(.primary)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.orange)
                            .frame(width: 30)
                        Text("Customer Service")
                        Spacer()
                        Text("+1 800-888-9999")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                            .onTapGesture {
                                if let url = URL(string: "tel://+18008889999"), UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url)
                                }
                            }
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        VStack {
                            Text("App Version 1.0.0")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            Text("Premium VR Experiences")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingPrivacyPolicy) {
                PrivacyPolicyView()
            }
        }
    }
}

struct AddressManagementView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Form {
            if let address = appState.currentAddress {
                Section(header: Text("Current Address")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(address.fullName)
                            .font(.headline)
                        Text(address.phoneNumber)
                            .foregroundColor(.secondary)
                        Text(address.streetAddress)
                        Text("\(address.city), \(address.state) \(address.zipCode)")
                    }
                    .padding(.vertical, 4)
                }
            }
            
            Section {
                Button(action: {
                    // Action to edit
                }) {
                    Text("Edit Address")
                        .foregroundColor(.blue)
                }
            }
        }
        .navigationTitle("Delivery Address")
    }
}

struct PrivacyPolicyView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Privacy Policy")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Last Updated: March 2026")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("1. Information Collection")
                        .font(.headline)
                    Text("We collect information necessary to provide you with the best VR rental experience. This includes your delivery address and contact details.")
                    
                    Text("2. Use of Information")
                        .font(.headline)
                    Text("Your information is strictly used for order fulfillment, customer support, and essential app functionality. We do not sell your personal data to third parties.")
                    
                    Text("3. Data Security")
                        .font(.headline)
                    Text("We implement robust security measures to protect your personal information on our internal servers.")
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitle("Privacy", displayMode: .inline)
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
