import SwiftUI

struct MyOrdersView: View {
    @EnvironmentObject var dataStore: DataStore
    
    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("My Rentals")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 16)
                
                if dataStore.orders.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "tent")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.3))
                        Text("No active rentals")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            ForEach(dataStore.orders) { order in
                                if let castle = dataStore.bouncyCastles.first(where: { $0.id == order.bouncyCastleId }) {
                                    OrderCardView(order: order, castle: castle)
                                        .environmentObject(dataStore)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 140) // Space for tab var
                    }
                }
            }
            .background(Color(hex: "#FAFAFA").edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
        }
    }
}

struct OrderCardView: View {
    let order: Order
    let castle: BouncyCastle
    @EnvironmentObject var dataStore: DataStore
    
    var body: some View {
        VStack(spacing: 0) {
            // Header: Date and Status
            HStack {
                Text(order.orderDate, style: .date)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                Spacer()
                Text(order.status.rawValue)
                    .font(.system(size: 12, weight: .bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.1))
                    .foregroundColor(statusColor)
                    .cornerRadius(8)
            }
            .padding(16)
            
            Divider()
            
            // Content
            HStack(alignment: .center, spacing: 16) {
                Image(castle.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(castle.name)
                        .font(.system(size: 16, weight: .bold))
                        .lineLimit(1)
                    
                    Text("Total: $\(String(format: "%.0f", order.totalAmount))")
                        .font(.system(size: 14, weight: .medium))
                    
                }
                
                Spacer()
            }
            .padding(16)
            
        }
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    var statusColor: Color {
        switch order.status {
        case .confirmed: return .blue
        case .pending: return .orange
        case .active: return .green
        case .completed: return .gray
        case .cancelled: return .red
        }
    }
}
