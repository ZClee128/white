import SwiftUI

struct OrderDetailView: View {
    let order: Order
    @EnvironmentObject var orderManager: OrderManager
    @Environment(\.dismiss) var dismiss
    @State private var showingReturnAlert = false
    
    // Find the latest order status directly from the manager
    var currentOrder: Order {
        if let found = orderManager.orders.first(where: { $0.id == order.id }) {
            return found
        }
        return order
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Status Header
                VStack(spacing: 8) {
                    Image(systemName: currentOrder.status == .renting ? "clock.fill" : "checkmark.seal.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(currentOrder.status == .renting ? .orange : .green)
                    
                    Text("Order \(currentOrder.status.rawValue)")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.top, 20)
                
                // Device Info
                VStack(alignment: .leading, spacing: 16) {
                    Text("Device Details")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 16) {
                        Image(currentOrder.console.name)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 60)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(12)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(currentOrder.console.name)
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Rental Duration: \(currentOrder.daysDuration) Days")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                
                // Timeline
                VStack(alignment: .leading, spacing: 16) {
                    Text("Rental Timeline")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 16) {
                        TimelineRow(title: "Start Date", date: currentOrder.startDate)
                        Divider()
                        TimelineRow(title: "Expected Return", date: currentOrder.endDate)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
                
                // Payment
                VStack(alignment: .leading, spacing: 16) {
                    Text("Payment Details")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 12) {
                        HStack {
                            Text("Total Amount")
                            Spacer()
                            Text("¥\(String(format: "%.0f", currentOrder.totalPrice))")
                                .fontWeight(.bold)
                        }
                        HStack {
                            Text("Deposit (Refundable)")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("¥\(String(format: "%.0f", currentOrder.console.deposit))")
                                .foregroundColor(.secondary)
                        }
                        
                        if currentOrder.status == .returned {
                            Divider()
                            HStack {
                                Text("Deposit Refunded")
                                    .foregroundColor(.green)
                                Spacer()
                                Text("¥\(String(format: "%.0f", currentOrder.console.deposit))")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
            }
            .padding()
        }
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .safeAreaInset(edge: .bottom) {
            if currentOrder.status == .renting {
                Button(action: {
                    showingReturnAlert = true
                }) {
                    Text("Return Console")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(16)
                        .shadow(color: .orange.opacity(0.3), radius: 5, x: 0, y: 5)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 10)
                .background(Color(UIColor.systemGroupedBackground).opacity(0.95))
            }
        }
        .alert("Return Console", isPresented: $showingReturnAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Confirm Return", role: .destructive) {
                orderManager.returnOrder(orderId: order.id)
            }
        } message: {
            Text("Are you sure you want to return this console? Your deposit of ¥\(String(format: "%.0f", currentOrder.console.deposit)) will be refunded.")
        }
    }
}

struct TimelineRow: View {
    let title: String
    let date: Date
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(date, style: .date)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    NavigationView {
        let order = Order(
            console: MockData.consoles[0],
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            totalPrice: 1560.0,
            status: .renting
        )
        OrderDetailView(order: order)
            .environmentObject(OrderManager())
    }
}
