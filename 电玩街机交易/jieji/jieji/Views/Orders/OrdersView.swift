import SwiftUI

struct OrdersView: View {
    @EnvironmentObject var orderManager: OrderManager
    @State private var showingNoWeChatAlert = false
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()
    
    var body: some View {
        NavigationView {
            Group {
                if orderManager.orders.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "list.clipboard")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        Text("No orders yet")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        ForEach(orderManager.orders) { order in
                            OrderRowView(order: order, dateFormatter: dateFormatter, showingNoWeChatAlert: $showingNoWeChatAlert)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("My Orders")
            .alert(isPresented: $showingNoWeChatAlert) {
                Alert(
                    title: Text("WeChat Not Installed"),
                    message: Text("WeChat is not installed on this device. Please install WeChat to complete the payment."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct OrderRowView: View {
    let order: Order
    let dateFormatter: DateFormatter
    @EnvironmentObject var orderManager: OrderManager
    @Binding var showingNoWeChatAlert: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(dateFormatter.string(from: order.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(order.status)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(order.status == "Paid" ? .green : .orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background((order.status == "Paid" ? Color.green : Color.orange).opacity(0.1))
                    .cornerRadius(8)
            }
            
            Divider()
            
            ForEach(order.items) { item in
                HStack(alignment: .top) {
                    Image(item.machine.name)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.machine.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        Text("Qty: \(item.quantity)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(String(format: "$%.2f", item.machine.price * Double(item.quantity)))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
            
            Divider()
            
            HStack {
                Text("Total:")
                    .font(.headline)
                Spacer()
                Text(String(format: "$%.2f", order.totalAmount))
                    .font(.headline)
                    .foregroundColor(.accentColor)
            }
            
            if order.status == "Pending Payment" {
                Button(action: {
                    if let url = URL(string: "weixin://"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                        // In a real app we'd wait for AppDelegate callback. Simulate success here.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            orderManager.updateOrderStatus(id: order.id, newStatus: "Paid")
                        }
                    } else {
                        showingNoWeChatAlert = true
                    }
                }) {
                    HStack {
                        Image(systemName: "message.fill")
                        Text("Pay with WeChat")
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.top, 8)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
