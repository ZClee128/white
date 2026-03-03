import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: StoreData
    
    @State private var showingCustomerService = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Orders Section
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
                                    NavigationLink(destination: OrderDetailView(order: order)) {
                                        VStack(alignment: .leading, spacing: 10) {
                                            HStack {
                                                Text("Order No. \(order.id.uuidString.prefix(8))")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                Spacer()
                                                if order.status == "Pending Payment" {
                                                    Text(order.status)
                                                        .font(.caption)
                                                        .fontWeight(.bold)
                                                        .foregroundColor(.orange)
                                                } else {
                                                    Text(order.status)
                                                        .font(.caption)
                                                        .foregroundColor(.green)
                                                }
                                                Text("•")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                                Text(order.date, style: .date)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                Image(systemName: "chevron.right")
                                                    .font(.caption)
                                                    .foregroundColor(.gray.opacity(0.5))
                                            }
                                            
                                            HStack {
                                                Text("Total \(order.items.count) items")
                                                    .foregroundColor(.primary)
                                                Spacer()
                                                Text(String(format: "Total: ¥%.2f", order.total))
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.red)
                                            }
                                        }
                                        .padding()
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    if order.id != store.orders.last?.id {
                                        Divider().padding(.horizontal)
                                    }
                                }
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal)
                        .padding(.top, 10) // Extra top padding since header is gone
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    }
                    
                    // Settings Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Settings")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 0) {
                            NavigationLink(destination: AddressListView(selectedAddress: .constant(nil), isSelectionMode: false)) {
                                SettingRow(icon: "map", title: "Address Management", color: .blue)
                            }
                            Divider().padding(.horizontal)
                            
                            Button(action: { showingCustomerService = true }) {
                                SettingRow(icon: "headphones", title: "Customer Service", color: .blue)
                            }
                            Divider().padding(.horizontal)
                            
                            NavigationLink(destination: PrivacyPolicyView()) {
                                SettingRow(icon: "doc.text", title: "Privacy Policy", color: .blue)
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
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .alert("Customer Service", isPresented: $showingCustomerService) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Customer service hours: Mon–Fri 09:00–18:00 (EST)\nHotline: +1 (800) 123-4567")
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
    SettingsView()
        .environmentObject(StoreData())
}
