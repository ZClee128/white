import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var store: StoreData
    
    @State private var showingCustomerService = false
    @State private var showingDeleteAlert = false
    @State private var showingLogin = false
    
    // Mask phone number: 13800138000 -> 138****8000
    private var maskedPhone: String {
        let phone = store.currentUserPhone
        guard phone.count == 11 else { return phone }
        let startIndex = phone.index(phone.startIndex, offsetBy: 3)
        let endIndex = phone.index(phone.startIndex, offsetBy: 7)
        return phone.replacingCharacters(in: startIndex..<endIndex, with: "****")
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 1. User Info Header Card
                    VStack {
                        HStack(spacing: 20) {
                            ZStack {
                                Circle()
                                    .fill(store.isLoggedIn ? Color.red : Color.gray.opacity(0.3))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                                    .offset(y: 5)
                            }
                            .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 8) {
                                if store.isLoggedIn {
                                    Text("Opera_Fan_001")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Text(maskedPhone)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                } else {
                                    Text("Not Logged In")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Button(action: { showingLogin = true }) {
                                        Text("Login/Register for full features")
                                            .font(.subheadline)
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding(20)
                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    
                    // 2. Orders Section
                    if store.isLoggedIn {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("My Orders")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 0) {
                                if store.orders.isEmpty {
                                    Text("No Order History")
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()
                                } else {
                                    ForEach(store.orders) { order in
                                        VStack(alignment: .leading, spacing: 10) {
                                            HStack {
                                                Text("Order No. \(order.id.uuidString.prefix(8))")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                Spacer()
                                                Text(order.date, style: .date)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                            HStack {
                                                Text("Total \(order.items.count) items")
                                                Spacer()
                                                Text(String(format: "Total: ¥%.2f", order.total))
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.red)
                                            }
                                        }
                                        .padding()
                                        
                                        if order.id != store.orders.last?.id {
                                            Divider().padding(.horizontal)
                                        }
                                    }
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding(.horizontal)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                        }
                    }
                    
                    // 3. Settings Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Settings")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 0) {
                            if store.isLoggedIn {
                                NavigationLink(destination: AddressListView(selectedAddress: .constant(nil), isSelectionMode: false)) {
                                    SettingRow(icon: "map", title: "Address Management", color: .blue)
                                }
                                Divider().padding(.horizontal)
                            }
                            
                            Button(action: { showingCustomerService = true }) {
                                SettingRow(icon: "headphones", title: "Customer Service", color: .blue)
                            }
                            Divider().padding(.horizontal)
                            
                            NavigationLink(destination: PrivacyPolicyView()) {
                                SettingRow(icon: "doc.text", title: "Privacy Policy", color: .blue)
                            }
                            
                            if store.isLoggedIn {
                                Divider().padding(.horizontal)
                                
                                Button(action: { store.logout() }) {
                                    SettingRow(icon: "arrow.right.square", title: "Log Out", color: .primary)
                                }
                                Divider().padding(.horizontal)
                                
                                Button(action: { showingDeleteAlert = true }) {
                                    SettingRow(icon: "xmark.bin", title: "Delete Account", color: .red)
                                }
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    }
                }
                .padding(.bottom, 40)
            }
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .alert("Customer Service", isPresented: $showingCustomerService) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Customer service hours: Mon–Fri 09:00–18:00 (EST)\nHotline: +1 (800) 123-4567")
            }
            .alert("Warning: Confirm account deletion?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Confirm Deletion", role: .destructive) {
                    store.deleteAccount()
                }
            } message: {
                Text("After account deletion, all your historical orders, cart, and personal information (including addresses) will be completely removed from the server and local storage. This operation cannot be reversed!")
            }
            .sheet(isPresented: $showingLogin) {
                LoginView()
            }
        }
    }
}

struct SettingRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24, height: 24)
            
            Text(title)
                .foregroundColor(color == .red ? .red : .primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.5))
                .font(.system(size: 14, weight: .semibold))
        }
        .padding()
    }
}

#Preview {
    ProfileView()
        .environmentObject(StoreData())
}

#Preview {
    ProfileView()
        .environmentObject(StoreData())
}
