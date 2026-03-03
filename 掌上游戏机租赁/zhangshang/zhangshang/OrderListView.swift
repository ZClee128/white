import SwiftUI

struct OrderListView: View {
    @EnvironmentObject var orderManager: OrderManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
                
                if orderManager.orders.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                        Text("No orders yet")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(orderManager.orders) { order in
                                NavigationLink(destination: OrderDetailView(order: order)) {
                                    OrderRowView(order: order)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("My Orders")
        }
    }
}

struct OrderRowView: View {
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(order.startDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(order.status.rawValue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(order.status == .renting ? Color.orange.opacity(0.2) : Color.green.opacity(0.2))
                    .foregroundColor(order.status == .renting ? .orange : .green)
                    .cornerRadius(8)
            }
            
            HStack(spacing: 16) {
                Image(order.console.name)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 50)
                    .padding(4)
                    .background(Color.white)
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.console.name)
                        .font(.headline)
                    Text("\(order.daysDuration) Days")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("¥\(String(format: "%.0f", order.totalPrice))")
                    .font(.headline)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    OrderListView()
        .environmentObject(OrderManager())
}
