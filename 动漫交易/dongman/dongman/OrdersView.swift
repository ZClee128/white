import SwiftUI

struct OrdersView: View {
    @EnvironmentObject var store: DataStore

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.07, green: 0.07, blue: 0.12).ignoresSafeArea()

                Group {
                    if store.orders.isEmpty {
                        emptyState
                    } else {
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 12) {
                                ForEach(store.orders) { order in
                                    NavigationLink {
                                        OrderDetailView(originalOrder: order)
                                            .environmentObject(store)
                                    } label: {
                                        OrderRow(order: order)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 8)
                            .padding(.bottom, 30)
                        }
                    }
                }
            }
            .navigationTitle("My Orders")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "shippingbox")
                .font(.system(size: 64))
                .foregroundColor(.gray.opacity(0.3))
            Text("No orders yet")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            Text("Browse the Market and buy your first figure!")
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }
}

// MARK: - Order Row

struct OrderRow: View {
    let order: Order

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.12, green: 0.12, blue: 0.2))
                    .frame(width: 60, height: 60)
                Image(order.figure.systemImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .cornerRadius(12)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(order.orderNumber)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(order.figure.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text(order.figure.series)
                    .font(.caption)
                    .foregroundColor(.gray)
                HStack(spacing: 6) {
                    Image(systemName: order.status.icon)
                        .font(.caption)
                    Text(order.status.rawValue)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .foregroundColor(order.status.color)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text("$\(String(format: "%.2f", order.total + 4.99 + 1.50))")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(orderDate(order.orderDate))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding(14)
        .background(Color(red: 0.1, green: 0.1, blue: 0.15))
        .cornerRadius(16)
    }

    private func orderDate(_ date: Date) -> String {
        let fmt = DateFormatter()
        fmt.dateStyle = .short
        return fmt.string(from: date)
    }
}
