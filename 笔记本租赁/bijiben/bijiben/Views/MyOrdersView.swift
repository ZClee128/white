import SwiftUI

struct MyOrdersView: View {
    @EnvironmentObject var store: RentalStore

    var body: some View {
        Group {
            if store.orders.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(store.orders) { order in
                            OrderCard(order: order)
                        }
                    }
                    .padding(16)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("My Orders")
        .navigationBarTitleDisplayMode(.large)

    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray")
                .font(.system(size: 56))
                .foregroundColor(Color(.systemGray3))

            VStack(spacing: 6) {
                Text("No Orders Yet")
                    .font(.title3.bold())
                    .foregroundColor(.primary)

                Text("Your rental orders will appear here.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Order Card
struct OrderCard: View {
    @EnvironmentObject var store: RentalStore
    let order: RentalOrder

    var statusColor: Color {
        switch order.status {
        case .pending: return .orange
        case .paid: return Color(hex: "0f3460")
        case .active: return .green
        case .returned: return .gray
        }
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: order.createdAt)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: order.status.icon)
                        .foregroundColor(statusColor)
                        .font(.subheadline)
                    Text(order.status.rawValue)
                        .font(.caption.bold())
                        .foregroundColor(statusColor)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(statusColor.opacity(0.1))
                .cornerRadius(8)

                Spacer()

                Text("#\(order.orderNumber)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 12)

            Divider()

            // Body
            HStack(spacing: 14) {
                if let matchedLaptop = store.laptops.first(where: { $0.id == order.laptopId }) {
                    Image(matchedLaptop.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .background(Color(hex: "f4f4f4"))
                        .cornerRadius(8)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: "1a1a2e"))
                            .frame(width: 50, height: 50)
                        Image(systemName: "laptopcomputer")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(order.laptopName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("\(order.laptopBrand) · \(order.duration.label)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(formattedDate)
                        .font(.caption2)
                        .foregroundColor(Color(.systemGray3))
                }

                Spacer()

                Text("$\(String(format: "%.0f", order.totalPrice))")
                    .font(.title3.bold())
                    .foregroundColor(Color(hex: "0f3460"))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)

            Divider()

            // Footer
            HStack {
                Image(systemName: "location.fill")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text(order.deliveryAddress)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
    }
}

#Preview {
    MyOrdersView()
        .environmentObject(RentalStore())
}
