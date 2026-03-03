import SwiftUI

struct SettingsView: View {
    @State private var showingClearDataAlert = false
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var orderManager: OrderManager
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account & Setup")) {
                    NavigationLink(destination: AddressListView()) {
                        HStack {
                            Image(systemName: "location.viewfinder")
                                .foregroundColor(.blue)
                                .frame(width: 30)
                            Text("Address Management")
                        }
                    }
                    
                    NavigationLink(destination: OrdersView()) {
                        HStack {
                            Image(systemName: "list.bullet.rectangle.portrait")
                                .foregroundColor(.orange)
                                .frame(width: 30)
                            Text("My Orders")
                        }
                    }
                }
                
                Section(header: Text("Support & Information")) {
                    NavigationLink(destination: ContactUsView()) {
                        HStack {
                            Image(systemName: "headphones")
                                .foregroundColor(.green)
                                .frame(width: 30)
                            Text("Contact Customer Service")
                        }
                    }
                    
                    NavigationLink(destination: PrivacyPolicyView()) {
                        HStack {
                            Image(systemName: "lock.shield")
                                .foregroundColor(.purple)
                                .frame(width: 30)
                            Text("Privacy Policy")
                        }
                    }
                }
                
                Section(header: Text("App Info")) {
//                    HStack {
//                        Text("Version")
//                        Spacer()
//                        Text("1.0.0")
//                            .foregroundColor(.secondary)
//                    }
                    
                    Button(action: {
                        showingClearDataAlert = true
                    }) {
                        Text("Clear App Data")
                            .foregroundColor(.red)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
            .alert(isPresented: $showingClearDataAlert) {
                Alert(
                    title: Text("Clear Data"),
                    message: Text("Are you sure you want to clear all carts and orders? This action cannot be undone."),
                    primaryButton: .destructive(Text("Clear")) {
                        cartManager.clearCart()
                        orderManager.orders.removeAll()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
