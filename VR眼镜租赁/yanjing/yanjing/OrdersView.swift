import SwiftUI

struct OrdersView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all)
                
                if appState.orders.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No orders yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                } else {
                    List {
                        ForEach(appState.orders.reversed()) { order in
                            OrderRowView(order: order)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Orders")
        }
    }
}

struct OrderRowView: View {
    var order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Order #\(order.orderNumber)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Text(order.status.rawValue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(statusColor(order.status))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor(order.status).opacity(0.1))
                    .cornerRadius(8)
            }
            
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: order.product.imageURL)) { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 60, height: 60)
                .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.product.name)
                        .font(.headline)
                    Text("\(order.rentalDays) days rental")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("$\(String(format: "%.2f", order.totalAmount))")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            
            if order.status == .pendingPayment {
                Button(action: {
                    // Logic to retry payment
                }) {
                    Text("Pay Now")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.top, 8)
            }
        }
        .padding(.vertical, 8)
    }
    
    func statusColor(_ status: OrderStatus) -> Color {
        switch status {
        case .pendingPayment: return .orange
        case .paid: return .green
        case .shipped: return .blue
        case .completed: return .gray
        case .canceled: return .red
        }
    }
}
