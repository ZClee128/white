import SwiftUI

struct OrderDetailView: View {
    let order: Order
    
    @State private var isPaying = false
    @State private var showWeChatAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                // Status Header
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Order Status")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        Text(order.status)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Image(systemName: order.status == "Pending Payment" ? "clock.fill" : "checkmark.seal.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                }
                .padding(20)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: order.status == "Pending Payment" ? [Color.orange, Color.yellow] : [Color.green, Color.mint]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(15)
                .padding(.horizontal)
                .padding(.top, 10)
                
                // Delivery Address
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "map.fill")
                            .foregroundColor(.red)
                        Text("Delivery Address")
                            .font(.headline)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(order.address.name)
                                .fontWeight(.bold)
                            Spacer()
                            Text(order.address.phone)
                                .foregroundColor(.secondary)
                        }
                        Text(order.address.detail)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                
                // Items List
                VStack(alignment: .leading, spacing: 10) {
                    Text("Order Items")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 0) {
                        ForEach(order.items) { item in
                            HStack(spacing: 15) {
                                Image(item.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(item.name)
                                        .font(.headline)
                                        .lineLimit(1)
                                    
                                    Text("\(item.characterRole) · \(item.playName)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Text(String(format: "¥%.2f", item.price))
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.red)
                                        Spacer()
                                        Text("x1")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 5)
                            }
                            .padding()
                            
                            if item.id != order.items.last?.id {
                                Divider().padding(.horizontal)
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                }
                
                // Order Info
                VStack(alignment: .leading, spacing: 15) {
                    Text("Order Information")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        OrderDetailInfoRow(title: "Order No.", value: order.id.uuidString.replacingOccurrences(of: "-", with: "").prefix(15).uppercased())
                        OrderDetailInfoRow(title: "Order Date", value: formatDate(order.date))
                        OrderDetailInfoRow(title: "Payment Method", value: order.paymentMethod)
                        Divider()
                        HStack {
                            Text("Total Amount")
                                .fontWeight(.medium)
                            Spacer()
                            Text(String(format: "¥%.2f", order.total))
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                }
                .padding(.bottom, 30) // existing padding
            }
        }
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            if order.status == "Pending Payment" {
                VStack {
                    Button(action: simulatePayment) {
                        HStack {
                            Spacer()
                            if isPaying {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Image(systemName: "w.circle.fill")
                                Text("WeChat Pay (¥\(String(format: "%.2f", order.total)))")
                            }
                            Spacer()
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(25)
                        .shadow(color: Color.green.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .disabled(isPaying)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
                .background(.ultraThinMaterial)
            }
        }
        .alert("Payment Failed", isPresented: $showWeChatAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("WeChat is not detected on your device. Please install WeChat from the App Store and try again.")
        }
    }
    
    private func simulatePayment() {
        isPaying = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.isPaying = false
            self.showWeChatAlert = true
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
}

private struct OrderDetailInfoRow: View {
    let title: String
    let value: String
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }
}
